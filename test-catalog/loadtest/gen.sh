#!/bin/bash

set -e

outFolder="generated"
allComponentsYaml="all-components.yaml"

cat <<EOF > "$allComponentsYaml"
apiVersion: backstage.io/v1alpha1
kind: Location
metadata:
  name: components
  description: A collection of all components
spec:
  targets:
EOF

for i in $(seq 1 10); do
    in=showcase-service-template.yaml
    out=$(echo $in | sed "s/.yaml/-$i.yaml/g")
    cat "$in" | sed "s/\$i/$i/g" > "$outFolder/$out"
done

for i in $(seq 1 100); do
    in=showcase-service-template.yaml
    out=$(echo $in | sed "s/.yaml/-$i.yaml/g")
    echo "    - ./$outFolder/$out"
done >> "$allComponentsYaml"
