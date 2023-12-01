FROM gradle:7.3.1-jdk17 AS builder
LABEL maintainer="axxis Security"

COPY --chown=gradle:gradle ./log4j-cve-2021-44228 /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle :malicious-server:bootJar --no-daemon

FROM openjdk:8u181-jdk-alpine

RUN mkdir /app
COPY --from=builder /home/gradle/src/malicious-server/build/libs/*.jar /app/malicious-server.jar

RUN mkdir -p /usr/local/tomcat/

WORKDIR /usr/local/tomcat
RUN wget --no-check-certificate http://dlcdn.apache.org/tomcat/tomcat-8/v8.5.73/bin/apache-tomcat-8.5.73.tar.gz
RUN tar xvfz apache*.tar.gz
RUN mv apache-tomcat-8.5.73/* /usr/local/tomcat/.

ADD start.sh /usr/local/tomcat/

# Copy the application to tomcat
ADD target/insecure-bank.war /usr/local/tomcat/webapps

# Copy the license file
ADD license.axxis /usr/local/tomcat/axxis/

# Copy the agent jar
ADD axxis-ee-agent.jar /usr/local/tomcat/axxis/

# Run Tomcat and enjoy!
CMD export JAVA_OPTS="-javaagent:axxis/axxis-ee-agent.jar \
  -Daxxis.config.dir=axxis/ \
  -Daxxis.console.url=http://console:8080/axxis-console-services \
  -Daxxis.console.token=04db250da579302ca273a958 \
  -Daxxis.server.name=Testing-Docker \
  -Daxxis.toolbar.enabled=true" && ./start.sh
