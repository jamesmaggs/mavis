# syntax=docker/dockerfile:1

# --- build stage ---------------------------------------------------------
# Pinned to match the local toolchain (mise.toml): Maven 3.9.16 on Temurin 25.
FROM maven:3.9.16-eclipse-temurin-25 AS build
WORKDIR /app

# Resolve dependencies first so they cache independently of source changes.
COPY pom.xml .
RUN mvn -B -ntp -DskipTests dependency:go-offline

# Build the shaded fat jar. Tests are the CI gate, not the deploy build.
COPY src ./src
RUN mvn -B -ntp -DskipTests package

# --- runtime stage -------------------------------------------------------
FROM eclipse-temurin:25.0.3_9-jre-noble
WORKDIR /app
COPY --from=build /app/target/mavis.jar app.jar

# Railway injects PORT at runtime; App.resolvePort reads it (else defaults).
CMD ["java", "-jar", "app.jar"]
