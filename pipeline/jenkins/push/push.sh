#!/bin/bash

echo "********************"
echo "** Pushing image ***"
echo "********************"

IMAGE="maven-project"
BUILD_TAG="3.9.9"

echo "** Logging in ***"
docker login -u qhuy131096 -p $PASS
echo "*** Tagging image ***"
docker tag $IMAGE:$BUILD_TAG qhuy131096/$IMAGE:$BUILD_TAG
echo "*** Pushing image ***"
docker push qhuy131096/$IMAGE:$BUILD_TAG