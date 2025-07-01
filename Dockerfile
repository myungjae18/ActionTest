FROM gradle:8.5-jdk17 AS builder
WORKDIR /workspace
COPY gradle gradle
COPY gradlew gradlew.bat settings.gradle.kts build.gradle.kts ./
RUN chmod +x gradlew
RUN ./gradlew build -x test --no-daemon || true
COPY . .
RUN ./gradlew clean bootJar --no-daemon

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /workspace/build/libs/*.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]
EXPOSE 8080