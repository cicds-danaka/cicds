# Build stage
FROM gradle:8.5-jdk21 AS builder
WORKDIR /app

# 전체 소스 복사 (한 번에)
COPY . .

# 빌드 실행
RUN gradle build -x test --no-daemon

# Runtime stage
FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
