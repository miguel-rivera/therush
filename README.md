# Installation


### Dependencies
- Docker 
- Postgres 
- Direnv (local development for loading env variables) 

### Running Dockerized Application

```bash
#start postgres and application
docker-compose up

#check running state 
docker ps 


#stop application
docker-compose down
```
- URL: http://localhost:4000/players
### useful commands

```bash
#IMPORT rushing.json file located in priv/repo/seeds folder 
/opt/app/prod/rel/rush/bin/rush eval "Rush.Utils.Releases.update_rushing()"
```