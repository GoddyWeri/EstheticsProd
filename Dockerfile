# Use an OpenJDK base image
#FROM openjdk:17-jdk-alpine

# Set the working directory inside the container
#WORKDIR /esthetics-app

# Copy the JAR file from the local target directory to the container's working directory
#COPY target/esthetics-0.0.1-SNAPSHOT.jar /esthetics-app/app.jar

# Expose the port your application will run on
#EXPOSE 8080

# Specify the command to run your application
#CMD ["java", "-jar", "app.jar"]


# STAGE 1: Build the application
FROM maven:3.8.4-openjdk-17 AS builder

WORKDIR /usr/src/app

COPY pom.xml .
RUN mvn verify --fail-never

COPY . .
#RUN mvn clean package

# STAGE 2: Setup the API server image
FROM amazoncorretto:11-alpine

WORKDIR /app

COPY --from=builder /usr/src/app/target/*.jar app.jar

# Set the default active Spring profile
ENV SPRING_PROFILES_ACTIVE=local

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=8080"]

