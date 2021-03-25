## Build locally

`cd rust-devcontainer`

`docker build -t ianpurton/rust-devcontainer .` 

## Create .devcontainer

```
mkdir .devcontainer \
  && curl -L https://github.com/ianpurton/development_environments/archive/master.zip -O -J \
  && unzip development_environments-master.zip \
  && mv development_environments-master/rust-devcontainer/Dockerfile.devcontainer .devcontainer/Dockerfile \
  && mv development_environments-master/rust-devcontainer/docker-compose.yml .devcontainer \
  && mv development_environments-master/rust-devcontainer/bash_history .devcontainer \
  && mv development_environments-master/rust-devcontainer/devcontainer.json .devcontainer \
  && rm -rf development_environments-master*
```

Windows

```
mkdir .devcontainer 
curl -L https://github.com/ianpurton/development_environments/archive/master.zip -O -J
tar -xf  development_environments-master.zip 
move development_environments-master\rust-devcontainer\Dockerfile.devcontainer .devcontainer\Dockerfile
move development_environments-master\rust-devcontainer\docker-compose.yml .devcontainer 
move development_environments-master\rust-devcontainer\devcontainer.json .devcontainer 
move development_environments-master\rust-devcontainer\bash_history .devcontainer 
del /S development_environments-master.zip
rmdir /S /Q development_environments-master
```
