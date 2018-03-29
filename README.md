# oracle-jdk8-maven3

## Build image

    docker-compose build

## Run from directory where a Maven pom.xml exists

    docker run -it --rm -v "$(pwd)":/jenkins -v $HOME/.m2:/jenkins/.m2 mavenjdkagent_jenkins mvn clean install
