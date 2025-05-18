#!/bin/bash

echo "***************************"
echo "** Testing the code ***********"
echo "***************************"
WORKSPACE=/home/jenkins/jenkins-data/jenkins_home/workspace/pipeline-docker-maven

docker run --rm  -v  /Users/huynq/code/jenkins/jenkins_home/pipeline/java-app:/app -v /Users/huynq/root/.m2/:/root/.m2/ -w /app maven:3-alpine "$@"