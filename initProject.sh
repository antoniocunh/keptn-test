#!/usr/bin/env bash

PROJECT="pod-tato-head"
IMAGE="ghcr.io/podtato-head/podtatoserver"
VERSION="$2"

case "$1" in
  "create-project")
    echo "Creating keptn project $PROJECT"
    echo keptn create project "${PROJECT}" --shipyard=./shipyard.yaml --git-user=$GIT_USER --git-token=$GIT_TOKEN --git-remote-url=$GIT_REMOTE_URL  
    keptn create project "${PROJECT}" --shipyard=./shipyard.yaml --git-user=$GIT_USER --git-token=$GIT_TOKEN --git-remote-url=$GIT_REMOTE_URL  
    ;;
  "onboard-service")
    echo "Onboarding keptn service helloservice in project ${PROJECT}"
    keptn create service helloservice --project="${PROJECT}" --all-stages --resource=helloservice.tgz --resourceUri=charts/helloservice
    ;;
  "first-deploy-service")
    echo "Deploying keptn service helloservice in project ${PROJECT}"
    keptn trigger delivery --project="${PROJECT}" --service=helloservice --image="${IMAGE}:v0.1.1"
    ;;
  "deploy-service")
    echo "Deploying keptn service helloservice in project ${PROJECT}"
    echo keptn trigger delivery --project="${PROJECT}" --service=helloservice --image="${IMAGE}" --tag=v"${VERSION}"
    keptn trigger delivery --project="${PROJECT}" --service=helloservice --image="${IMAGE}" --tag=v"${VERSION}"
    ;;    
  "upgrade-service")
    echo "Upgrading keptn service helloservice in project ${PROJECT}"
    keptn trigger delivery --project="${PROJECT}" --service=helloservice --image="${IMAGE}" --tag=v0.1.0
    ;;
  "slow-build")
    echo "Deploying slow build version of helloservice in project ${PROJECT}"
    keptn trigger delivery --project="${PROJECT}" --service=helloservice --image="${IMAGE}" --tag=v0.1.2
    ;;
  "add-quality-gates")
    echo "Adding keptn quality-gates to project ${PROJECT}"
    keptn add-resource --project=pod-tato-head --stage=hardening --service=helloservice --resource=prometheus/sli.yaml --resourceUri=prometheus/sli.yaml
    keptn add-resource --project=pod-tato-head --stage=hardening --service=helloservice --resource=slo.yaml --resourceUri=slo.yaml
    ;;
  "add-jmeter-tests")
    echo "Adding jmeter load tests to project ${PROJECT}"
    keptn add-resource --project=pod-tato-head --stage=hardening --service=helloservice --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx
    keptn add-resource --project=pod-tato-head --stage=hardening --service=helloservice --resource=jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    ;;
esac
