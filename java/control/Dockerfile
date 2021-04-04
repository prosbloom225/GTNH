FROM openjdk:8-jre-alpine3.9
 
 # copy the packaged jar file into our docker image
 COPY target/control-0.0.1-SNAPSHOT.jar /control.jar
  
  # set the startup command to execute the jar
  CMD ["java", "-jar", "/control.jar"]
