# oracle-jdk8-maven3

## Build image

    docker build -t oraclejdk8maven3:latest .

## Run from directory where a Maven pom.xml exists

    docker run -it --rm -v "$(pwd)":/jenkins -v $HOME/.m2:/jenkins/.m2 oraclejdk8maven3 mvn clean install
