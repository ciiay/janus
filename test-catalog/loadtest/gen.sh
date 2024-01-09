#!/bin/bash

set -e

items=${1:-100}

outFolder="generated"

allComponentsYaml="$outFolder/all-components.yaml"

mkdir -p "$outFolder"

cat <<EOF > "$allComponentsYaml"
apiVersion: backstage.io/v1alpha1
kind: Location
metadata:
  name: components
  description: A collection of all components
spec:
  targets:
EOF

echo "Will generate  $items  components in folder  $outFolder  and add them to  $allComponentsYaml ..."

for i in $(seq 1 $items); do
    in=showcase-service-template.yaml
    out=$(echo $in | sed "s/.yaml/-$i.yaml/g")
    cat "$in" | sed "s/\$i/$i/g" > "$outFolder/$out"
done

for i in $(seq 1 $items); do
    in=showcase-service-template.yaml
    out=$(echo $in | sed "s/.yaml/-$i.yaml/g")
    echo "    - ./$outFolder/$out"
done >> "$allComponentsYaml"

echo "Done."
echo
echo "Please include this into your app-config.yaml:"
echo
echo "catalog:"
echo "  locations:"
echo "    - type: file"
echo "      target: $(pwd)/$allComponentsYaml"
echo 
