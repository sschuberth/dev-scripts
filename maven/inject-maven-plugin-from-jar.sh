#!/bin/bash

POM_FILE=$1

# Pretent that the plugin is only available locally.
curl -o cyclonedx-maven-plugin.jar https://repo1.maven.org/maven2/org/cyclonedx/cyclonedx-maven-plugin/2.8.1/cyclonedx-maven-plugin-2.8.1.jar

# Install the plugin JAR to the local Maven repository in order to be able to refer to it via GAV coordinates.
mvn org.apache.maven.plugins:maven-install-plugin:3.1.3:install-file -Dfile=cyclonedx-maven-plugin.jar

# Run the plugin's "makeAggregateBom" goal on the provided POM file.
mvn org.cyclonedx:cyclonedx-maven-plugin:2.8.1:makeAggregateBom -f $POM_FILE

# Remove the downloaded plugin JAR.
rm cyclonedx-maven-plugin.jar
