# Commands
```
docker build -t ubuntu_custom:v2 .
docker run --name ubuntu_custom -v "${PWD}:/app" -w /app ubuntu_custom:v2
docker exec -it ubuntu_custom /bin/bash
```

## for windows
```
winpty docker run -it --name ubuntu_custom -v "${PWD}:/app" -w //app ubuntu_custom:v2
winpty docker exec -it ubuntu_custom //bin/bash
```

## for linux
```
docker run -it --name ubuntu_custom -v "${PWD}:/app" -w /app ubuntu_custom:v2

```

## Docker-compose for simple use
```
docker-compose run --rm ubuntu_custom
docker-compose down --rmi all
```

# Docker in Docker (New)
```
docker build -t dind:v1 .
docker run -it -v "${PWD}:/app"  --name dind dind:v1 /bin/bas
```
