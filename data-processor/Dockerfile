FROM maven:3.9.9-eclipse-temurin-17
WORKDIR /app
COPY . .
RUN mvn clean package
ENTRYPOINT ["java", "-jar", "target/app.jar"]