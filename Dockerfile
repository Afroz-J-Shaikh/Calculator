# docker file for maven based java project
# Stage 1: Build

FROM maven:3.9.6-eclipse-temurin-17 AS build
RUN apt-get update && apt-get install -y xvfb
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Stage 2: Run
FROM openjdk:17-jdk-slim
WORKDIR /app

RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY --from=build /build/target/*.jar app.jar
EXPOSE 8000
CMD ["xvfb-run", "java", "-jar", "app.jar"]
