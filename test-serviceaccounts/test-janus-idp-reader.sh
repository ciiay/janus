#!/bin/bash

# serviceaccount
user="janus-idp-reader"

token=$(oc create token --duration=168h "$user")
whoami=$(oc "--token=$token" whoami)

echo
echo "whoami: $whoami"
echo

#oc "--token=$token" get --all-namespaces pipelineruns

oc "--token=$token" get --all-namespaces pods.metrics.k8s.io
