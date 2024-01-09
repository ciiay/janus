# Super simple loadtest generator

Generates a number of backstage catalog components and a `Location` file to include just one file into your `app-config.yaml`

Run:

```
./gen.sh 100
```

Include into your `app-config.yaml`:


```yaml
catalog:
  locations:
    - type: file
      target: ......./generated/$allComponentsYaml
```
