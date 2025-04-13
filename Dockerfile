FROM gradle:8.5-jdk21 AS builder
WORKDIR /app

COPY . .
RUN chmod +x ./gradlew
RUN ./gradlew clean build -x test --stacktrace

FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
