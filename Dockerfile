# docker file for maven based java project
# Stage 1: Build
FROM maven:3.8.7-openjdk-17 AS build
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Stage 2: Run
FROM openjdk:17-jdk-slim-bookworm
WORKDIR /app
RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY --from=build /build/target/*.jar app.jar
EXPOSE 8000
CMD ["java", "-jar", "app.jar"]
