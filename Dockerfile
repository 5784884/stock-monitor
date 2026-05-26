# 使用多阶段构建
FROM gradle:8.5-jdk17 AS backend-build
WORKDIR /app
COPY build.gradle settings.gradle ./
COPY src ./src
RUN gradle build -x test --no-daemon

# 后端运行环境
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=backend-build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
