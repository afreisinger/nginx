#!/bin/sh
gitlab-runner exec shell --env "CI_REGISTRY_USER=afreisinger"  \                     2.54  13:22:59  62%
--env "CI_REGISTRY_PASSWORD=PASSWORD" \ 
--env "CI_REGISTRY=registry.gitlab.com" \
--env "CI_PIPELINE_ID=777363010" \
--env "CI_PROJECT_PATH=afreisinger/nginx" \
--env "CI_COMMIT_REF_SLUG=feature" \
--env "DOCKERHUB_REGISTRY_USER=afreisinger"  \
--env "DOCKERHUB_REGISTRY_PASSWORD=PASSWORD" \
--env "DOCKERHUB_REGISTRY=docker.io" \