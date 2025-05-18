#!/bin/bash

echo "***************************"
echo "** Building jar ***********"
echo "***************************"

WORKSPACE=/home/jenkins/jenkins_home/workspace/pipeline-docker-maven

# docker run --rm  -v  /var/jenkins_home/pipeline/java-app:/app -v /root/.m2/:/root/.m2/ -w /app maven:3.9.9 "$@"
docker run --rm \
  -v /Users/huynq/code/jenkins/jenkins_home/pipeline/java-app:/app \
  -v /Users/huynq/.m2:/root/.m2 \
  -w /app \
  maven:3.9.9 "$@"