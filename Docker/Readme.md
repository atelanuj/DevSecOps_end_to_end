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
docker run -it --network host --privileged=true --name dev-container -v "${PWD}:/app"  anujatel/ubuntu-dind:v2 /bin/bash
```

## Docker-compose for simple use
```
docker-compose run --rm ubuntu_custom
docker-compose down --rmi all
```

# ubuntu-dind Docker in Docker (New)
```
docker-compose run --rm ubuntu-dind
docker-compose down --rmi all
```
