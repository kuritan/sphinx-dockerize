# sphinx-dockerize
Simple [sphinx](https://github.com/sphinx-doc/sphinx) environment  
In order to assist in teaching the building of [sphinx](https://github.com/sphinx-doc/sphinx) applications.

## Info, documentation and support about sphinx-doc
Please see the [official documentation](https://www.sphinx-doc.org/en/master/) for installation and support instructions.  

# Prerequisite
- docker 17.05 or later
- python3(option)
- pip3(option)
# Usage
## Local develop
### step by step
- build docker image
```
$ git clone <this repository>
$ cd <this repository folder>
$ docker build --no-cache=true -t <the-docker-image-name>:<tag> .
```

- creat a doc project

```
$ ​docker run -it -v $PWD:/root <the-docker-image-name> quickstart
```

It will create a dir named 'test-project'. You can change the dir's name via 'entrypoint.sh'.

- build doc project contents

```
$ ​docker run -it -v $PWD:/root <the-docker-image-name> build
```

- run doc project container

```
$ ​docker run -it -p 8000:8000 -v $PWD:/root <the-docker-image-name> serve
```

### just one command(option)
We also provide a shell script(named sphinxdockerize.sh) help you to do both ___build___ and ___serve___ action.

First you need give execute permission to the script, and install sphinx by yourself.

```
$ chmod +x sphinxdockerize.sh
$ pip3 install -r requirements.txt
```

- For ___build___
    - build docs and package all site contents

```
$ ./sphinxdockerize.sh build
```

- For ___serve___
    - after ___build___ stage, extract built site contents and running sphinx-doc
```
$ ./sphinxdockerize.sh serve
```
