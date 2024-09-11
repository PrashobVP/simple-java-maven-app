# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file built by Maven into the container
COPY target/my-app-1.0-SNAPSHOT.jar /app/my-app.jar

# Expose port 5000 for the application
EXPOSE 5000

# Run the JAR file
CMD ["java", "-jar", "my-app.jar"]
