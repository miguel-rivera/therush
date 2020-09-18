######################
### STAGE 1: BUILD ###
######################

FROM bitwalker/alpine-elixir-phoenix:1.10.3 as build

# The following are build arguments used to change variable parts of the image.
# The environment to build with
ARG APP_VERSION=0.0.1
ARG MIX_ENV=prod
ARG PORT=4000

# Set environment variables
ENV LANG=en_US.UTF-8 \
	TERM=xterm \
	HOME=/opt/app/ \
	APP_VERSION=${APP_VERSION} \
	MIX_ENV=${MIX_ENV} \
	PORT=${PORT}

# install build dependencies
RUN apk add --update git build-base nodejs yarn python

# Add support for development and debugging
RUN apk update && apk upgrade && apk add --no-cache bash
RUN apk add bash-doc
RUN apk add bash-completion

# Copy source code into the container
COPY . $HOME

WORKDIR $HOME

# Install Rebar and Hex
RUN mix local.rebar --force
RUN mix local.hex --force

RUN mix deps.clean --all
# Cache Elixir deps
RUN mix deps.get --only ${MIX_ENV}


# build assets
COPY assets assets
RUN cd assets && yarn install && yarn run webpack --mode production
RUN mix phx.digest

# Compile app
RUN mix compile

# Generate release
RUN MIX_ENV=${MIX_ENV} mix release 

############################
#### STAGE 2: DEPLOYMENT ###
############################

FROM bitwalker/alpine-elixir-phoenix:1.10.3

# The following are build arguments used to change variable parts of the image.
# The version of the application we are building (required)
ARG APP_VERSION=0.0.1
ARG MIX_ENV=prod
ARG PORT=4000

# Set environment variables
ENV LANG=en_US.UTF-8 \
	TERM=xterm \
	HOME=/opt/app/ \
	APP_VERSION=${APP_VERSION} \
	MIX_ENV=${MIX_ENV} \
	PORT=${PORT} \
    POSTGRES_USERNAME=postgres \
    POSTGRES_PASSWORD=password \
    POSTGRES_HOST=localhost \
    POSTGRES_DATABASE=postgres \
    POSTGRES_PORT=5432 \
	POSTGRES_SALT=FjXmDDcYTYYWjQCF \
	SECRET_KEY_BASE=RyPfBuSUW1HGoLgbjexlm1Co//Glfq8EuhV8YM3Tg9FmdL2MXIxGEywck/a/hvHh
# Expose port
EXPOSE 4000

# Copy and extract .tar.gz to release file from the previous stage
COPY --from=build $HOME/_build/ $HOME
COPY --from=build $HOME/scripts $HOME/scripts

RUN chown -R default $HOME/prod
RUN chmod +x scripts/start.sh
# Change user
USER default


CMD ["/opt/app/scripts/start.sh"]