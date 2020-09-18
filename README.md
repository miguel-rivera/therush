# Installation


### Dependencies
- Docker `brew install docker`
- postgres `docker pull postgres`

### Running Dockerized Application

```bash
#start postgres and application
docker-compose up

#check running state 
docker ps 

#stop application
docker-compose down
```

### useful commands

```bash
#IMPORT rushing.json file located in priv/repo/seeds folder 
/opt/app/prod/rel/rush/bin/rush eval "Rush.Utils.Releases.update_rushing()"
```