#!/bin/bash

oc create serviceaccount janus-idp-reader

# kubernetes core
oc create clusterrole janus-idp-kubernetes-core-reader \
    --verb=get,watch,list \
    --resource=pods \
    --resource=pods/log \
    --resource=jobs \
    --resource=cronjobs \
    --resource=ingresses \
    --resource=statefulsets \
    --resource=configmaps \
    --resource=daemonsets \
    --resource=routes \
    --resource=limitranges \
    --resource=resourcequotas \
    --resource=deployments \
    --resource=replicasets \
    --resource=horizontalpodautoscalers \
    --resource=services

# kubernetes metrics
oc create clusterrole janus-idp-kubernetes-metrics-reader \
    --verb=get,watch,list \
    --resource=pods.metrics.k8s.io

# openshift imagestreams
oc create clusterrole janus-idp-openshift-imagestream-reader \
    --verb=get,watch,list \
    --resource=imagestreams.image.openshift.io \
    --resource=imagestreamtags.image.openshift.io

# tekton
oc create clusterrole janus-idp-tekton-reader \
    --verb=get,watch,list \
    --resource=tasks.tekton.dev \
    --resource=taskruns.tekton.dev \
    --resource=pipelines.tekton.dev \
    --resource=pipelineruns.tekton.dev

oc adm policy add-cluster-role-to-user janus-idp-kubernetes-core-reader -z janus-idp-reader
oc adm policy add-cluster-role-to-user janus-idp-kubernetes-metrics-reader -z janus-idp-reader
oc adm policy add-cluster-role-to-user janus-idp-openshift-imagestream-reader -z janus-idp-reader
oc adm policy add-cluster-role-to-user janus-idp-tekton-reader -z janus-idp-reader
