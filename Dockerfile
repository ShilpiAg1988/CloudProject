
  # FROM openjdk:11-jdk-slim
  # VOLUME /tmp
  # COPY target/oci-spring-app-0.0.1-SNAPSHOT.jar app.jar
  # ENTRYPOINT ["java","-jar","/app.jar"]
  FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y pandoc texlive texlive-xetex && \
    apt-get clean

WORKDIR /workspace