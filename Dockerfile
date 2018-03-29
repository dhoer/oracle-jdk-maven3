FROM centos:7

ARG JAVA_VERSION=8u162
ARG JAVA_BUILD=b12
ARG JAVA_HASH=0da788060d494f5095bf8624735fa2f1

ENV JAVA_HOME=/usr/java/default

RUN yum update -y \
  && yum install -y git \
  && mkdir /usr/java \
  && curl --create-dirs -L --retry 2 --retry-delay 2 --connect-timeout 30 \
     --cookie "oraclelicense=accept-securebackup-cookie;gpw_e24=http://edelivery.oracle.com" \
     http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}-${JAVA_BUILD}/${JAVA_HASH}/jdk-${JAVA_VERSION}-linux-x64.rpm \
     -o /tmp/jdk-linux-x64.rpm \
  && rpm -ivh /tmp/jdk-linux-x64.rpm \
  && rm -f /tmp/jdk-linux-x64.rpm \
  && rm -rf /var/log/* \
  && mkdir -p /etc/oracle/java/ \
  && echo "com.oracle.usagetracker.track.last.usage=false" > /etc/oracle/java/usagetracker.properties

ARG MAVEN_VERSION=3.5.3
ARG SHA=b52956373fab1dd4277926507ab189fb797b3bc51a2a267a193c931fffad8408
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

ENV MAVEN_HOME /usr/share/maven

RUN mkdir -p /usr/share/maven \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C $MAVEN_HOME --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s $MAVEN_HOME/bin/mvn /usr/bin/mvn

COPY ./settings.xml $MAVEN_HOME/conf/settings.xml

RUN groupadd --system jenkins && useradd --home-dir /jenkins --create-home --shell /bin/bash --gid jenkins jenkins

USER jenkins

WORKDIR /jenkins

CMD ["mvn", "--help"]
