#!/bin/bash

# Perform a deployment onto Kubernetes by updating an existing K8s deployment
# with a new container image.
#

# Connect to the EKS cluster.
source /bin/connect-eks.sh

# Make sure we have information needed for deployment.
if [ -z ${PLUGIN_TAG} ]; then
  echo "TAG must be defined"
  exit 1
fi

if [ -z ${PLUGIN_NAMESPACE} ]; then
  echo "NAMESPACE must be defined"
  exit 1
fi

if [ -z ${PLUGIN_RELEASE_NAME} ]; then
  echo "RELEASE_NAME must be defined"
  exit 1
fi

if [ -z ${PLUGIN_CHART_PATH} ]; then
  echo "CHART_PATH must be defined"
  exit 1
fi

if [ -z ${PLUGIN_ADDITIONAL_SETTINGS} ]; then
  PLUGIN_ADDITIONAL_SETTINGS=""
else
  IFS=',' read -r -a ADDITIONAL_SETTINGS <<< "${PLUGIN_ADDITIONAL_SETTINGS}"
  PLUGIN_ADDITIONAL_SETTINGS="${ADDITIONAL_SETTINGS[@]/#/--set }"
fi

helm upgrade $PLUGIN_RELEASE_NAME $PLUGIN_CHART_PATH --install --reset-values --namespace $PLUGIN_NAMESPACE $PLUGIN_ADDITIONAL_SETTINGS --set image.pullPolicy=Always --set image.tag=$PLUGIN_TAG
