FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/java-spring-devops-0.0.1-SNAPSHOT.jar app.jar
ENV APP_VERSION=1.0
ENTRYPOINT ["java", "-jar", "app.jar"]