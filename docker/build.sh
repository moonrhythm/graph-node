#! /bin/bash

# This file is only here to ease testing/development. Official images are
# built using the 'cloudbuild.yaml' file

type -p podman > /dev/null && docker=podman || docker=docker

cd $(dirname $0)/..

if [ -d .git ]
then
    COMMIT_SHA=$(git rev-parse HEAD)
    TAG_NAME=$(git tag --points-at HEAD)
    REPO_NAME="Checkout of $(git remote get-url origin) at $(git describe --dirty)"
    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
fi
#for stage in graph-node-build graph-node graph-node-debug
#do
#    $docker build --target $stage \
#            --build-arg "COMMIT_SHA=$COMMIT_SHA" \
#            --build-arg "REPO_NAME=$REPO_NAME" \
#            --build-arg "BRANCH_NAME=$BRANCH_NAME" \
#            --build-arg "TAG_NAME=$TAG_NAME" \
#            -t $stage \
#            -f docker/Dockerfile .
#done

buildctl build \
        --frontend dockerfile.v0 \
        --local dockerfile=docker \
        --local context=. \
        --opt target=graph-node \
        --opt build-arg=COMMIT_SHA=$COMMIT_SHA \
        --opt build-arg=REPO_NAME=$REPO_NAME \
        --opt build-arg=BRANCH_NAME=$BRANCH_NAME \
        --output type=image,name=gcr.io/moonrhythm-containers/graph-node:$BRANCH_NAME,push=true
