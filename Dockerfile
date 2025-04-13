# 1단계: Build stage
FROM gradle:8.5-jdk21 AS builder
WORKDIR /app

# 의존성 캐싱을 위해 먼저 복사
COPY build.gradle settings.gradle ./
COPY gradle ./gradle
RUN gradle --no-daemon dependencies

# 전체 소스 복사 후 빌드
COPY . .
RUN gradle build -x test --no-daemon

# 2단계: Runtime stage
FROM eclipse-temurin:21-jre
WORKDIR /app

# fat jar 복사 (이름은 실제 jar 이름에 맞게 조정 가능)
COPY --from=builder /app/build/libs/*.jar app.jar

# 실행
ENTRYPOINT ["java", "-jar", "app.jar"]