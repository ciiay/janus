#!/bin/bash

oc new-project christoph-backstage-test

for i in $(seq 1 10); do
    oc create -f ../plugins/tekton/christoph-demo1-service-pipeline-run.yaml
done

for i in $(seq 1 20); do
    oc create -f ../plugins/tekton/christoph-demo2-service-pipeline-run.yaml
done

for i in $(seq 1 30); do
    oc create -f ../plugins/tekton/christoph-demo3-service-pipeline-run.yaml
done
