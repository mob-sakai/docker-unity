#!/usr/bin/env bash -ex

source .env

UNITY_VERSION=${1:-2021.1.0a7}
MODULE=${2:-base}
CHANGESET=`unity-changeset $UNITY_VERSION`

REPO_LATEST_TAG=`git tag --sort='v:refname' \
            | tail -n 1 \
            | cut -d '/' -f 3`

ARGUMETNS="$(echo \
    --build-arg hubImage=$HUB_IMAGE:$REPO_LATEST_TAG \
    --build-arg baseImage=$BASE_IMAGE:$REPO_LATEST_TAG \
    --build-arg version=$UNITY_VERSION \
    --build-arg changeSet=$CHANGESET \
    --build-arg module=$MODULE \
    --tag $EDITOR_IMAGE:$UNITY_VERSION-$MODULE-dev \
    --tag $EDITOR_IMAGE:$UNITY_VERSION-$MODULE-$REPO_LATEST_TAG-dev \
)"

if [ "$MODULE" = 'base'] ; then
    docker build -f dockerfiles/editor.Dockerfile $ARGUMETNS .
else
    docker build -f dockerfiles/editor_module.Dockerfile $ARGUMETNS .
fi
