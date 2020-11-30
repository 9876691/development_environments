## Build locally

`cd rust-devcontainer`

`docker build -t ianpurton/rust-devcontainer .` 

## Create .devcontainer

```
mkdir .devcontainer \
  && curl -L https://github.com/ianpurton/development_environments/archive/master.zip -O -J \
  && unzip development_environments-master.zip \
  && mv development_environments-master/rust-devcontainer/Dockerfile .devcontainer \
  && mv development_environments-master/rust-devcontainer/docker-compose.yml .devcontainer \
  && mv development_environments-master/rust-devcontainer/devcontainer.json .devcontainer \
  && rm -rf development_environments-master*
```
