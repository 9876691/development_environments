## Build locally

`cd new-rust-devcontainer`

`docker build -t ianpurton/rust-slim-devcontainer .` 


## Start a new Project

`mkdir proj-name`

`cd proj-name`

`cargo init`

## Create .devcontainer

```
mkdir .devcontainer \
  && curl -L https://github.com/ianpurton/development_environments/archive/master.zip -O -J \
  && unzip development_environments-master.zip \
  && mv development_environments-master/new-rust-devcontainer/Dockerfile.devcontainer .devcontainer/Dockerfile \
  && mv development_environments-master/new-rust-devcontainer/docker-compose.yml .devcontainer \
  && mv development_environments-master/new-rust-devcontainer/devcontainer.json .devcontainer \
  && mv development_environments-master/new-rust-devcontainer/ps1.bash .devcontainer \
  && mv development_environments-master/new-rust-devcontainer/aliases.bash .devcontainer \
  && rm -rf development_environments-master*
```

Windows

```
mkdir .devcontainer 
curl -L https://github.com/ianpurton/development_environments/archive/master.zip -O -J
tar -xf  development_environments-master.zip 
move development_environments-master\new-rust-devcontainer\Dockerfile.devcontainer .devcontainer\Dockerfile
move development_environments-master\new-rust-devcontainer\docker-compose.yml .devcontainer 
move development_environments-master\new-rust-devcontainer\devcontainer.json .devcontainer 
move development_environments-master\new-rust-devcontainer\ps1.bash .devcontainer 
move development_environments-master\new-rust-devcontainer\aliases.bash .devcontainer 
del /S development_environments-master.zip
rmdir /S /Q development_environments-master
```
