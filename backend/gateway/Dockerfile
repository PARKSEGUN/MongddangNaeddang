# step 1: prepare build environment
FROM gradle:8.9.0-jdk17 AS builder
WORKDIR /home/gradle/project

# copy gradle wrapper and build.gradle files first to leverage caching
COPY gradle /home/gradle/project/gradle
COPY gradlew /home/gradle/project/
COPY build.gradle /home/gradle/project/
COPY settings.gradle /home/gradle/project/

# copy the rest of the project files
COPY . .

# step2: build the project => saved inside of the container
RUN ./gradlew build

# step3: create the docker image
FROM eclipse-temurin:17-jdk
WORKDIR /app

# copy build JAR file from the build stage
COPY --from=builder /home/gradle/project/build/libs/*.jar app.jar

# define a volume for persistent storage
VOLUME /app/data

# set the entry point to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
