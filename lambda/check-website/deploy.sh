#!/bin/bash

BUCKET_NAME=item-lambdas
version=$1
#version=`git describe --tags`

if [[ -z "$version" ]] ; then
    echo "Usage: $0 VERSION_NUMER"
    exit 1
fi


if ! ./gradlew clean shadowjar ; then
    echo "Failed to build"
    exit 1
fi

aws s3 cp build/libs/check-website-1.0-SNAPSHOT-all.jar s3://$BUCKET_NAME/check-website/check-website-$version.jar
