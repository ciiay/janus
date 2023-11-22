# Test

## Setup

<!--
Based on https://docs.google.com/document/d/1X40OGE7h0UW-nNGnkqW1ymsmgsK4zICmMuHvzFHlUzw/edit

https://gist.github.com/rhdh-bot/63cef5cb6285889527bd6a67c0e1c2a9
-->

1. Start a cluster and login
2. Create a project
3. Apply quay.io secret

```
oc login...

export namespace=christoph-$(date '+%H-%M')

oc new-project $namespace

oc apply -n $namespace -f rhdh-pull-secret.yaml

export version=1.0-185-CI

helm install -n $namespace --generate-name https://github.com/rhdh-bot/openshift-helm-charts/raw/developer-hub-$version/charts/redhat/redhat/developer-hub/$version/developer-hub-$version.tgz
```

## Summary

```
OpenShift version: 4.14.2
RHDH version: 1.0-185-CI
```
