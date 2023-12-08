# Auth0 test

Upstream documentation:

* https://backstage.io/docs/auth/auth0/provider/

## Test data

My test application is: https://manage.auth0.com/dashboard/us/dev-1wng4bqexvtlnxuv/applications/0ztLbWs7kO2OhIBW4I7AVFgPazIl0YB7/settings

## Test setup

* Create an **Auth0 account and application** on [https://manage.auth0.com/dashboard/]
  * An "Allowed Callback URLs" needs to be configured after the RHDH installation is created.
  * Create a user under User Management > Users (you must validate the e-mail address)
* **Setup an OCP cluster and RHDH**
  * Start a cluster
  * Create a new project/namespace
  * Apply the rhdh-pull-secret.yaml
  * Install RHDH with helm chart (used 1.0-185-CI from [https://gist.github.com/rhdh-bot/63cef5cb6285889527bd6a67c0e1c2a9])
  * Get the Route URL from the OpenShift Console or with this command and add it on the Auth0 Application page, in the Settings tab to "Allowed Callback URLs"
    ```
    echo -n 'https://' && oc get route developer-hub '-o=jsonpath={.spec.host}'
    ```
* **Setup Auth0 provider**
  * Change the app-config or apply a new one. I applied the app-config changes to the existing ConfigMap because the helm form didn't allow us currently to edit and upgrade it easily!
  * *Fix* all URLs that ends with .apps.example.com and replace them with the right URL from the route above!
  * Apply this app-config:
    ```yaml
    kind: ConfigMap
    apiVersion: v1
    metadata:
    name: auth0-app-config
    data:
    auth0-config.yaml: |
        app:
        title: Auth0 app config
        auth:
        environment: development
        providers:
            auth0:
            development:
                clientId: ${AUTH_AUTH0_CLIENT_ID}
                clientSecret: ${AUTH_AUTH0_CLIENT_SECRET}
                domain: ${AUTH_AUTH0_DOMAIN_ID}
        session:
            secret: ${AUTH_SESSION_SECRET}
        signInPage: auth0
    ```
  * Created a new Secret with the auth0 clientId and secret that looks like this:
    ```yaml
    # My secrets are from https://manage.auth0.com/dashboard/us/dev-1wng4bqexvtlnxuv/applications/0ztLbWs7kO2OhIBW4I7AVFgPazIl0YB7/settings
    # Session secret was generated with tr -dc A-Za-z0-9 </dev/urandom | head -c 32; echo
    apiVersion: v1
    kind: Secret
    metadata:
    name: auth0-secrets
    type: kubernetes.io/dockerconfigjson
    stringData:
    AUTH_AUTH0_CLIENT_ID: ...
    AUTH_AUTH0_CLIENT_SECRET: ...
    AUTH_AUTH0_DOMAIN_ID: ...
    AUTH_SESSION_SECRET: ...
    ```
  * Added the four secrets to the Deployment container env variables:
    ```yaml
                - name: AUTH_AUTH0_CLIENT_ID
                  valueFrom:
                    secretKeyRef:
                    name: auth0-secrets
                    key: AUTH_AUTH0_CLIENT_ID
                - name: AUTH_AUTH0_CLIENT_SECRET
                  valueFrom:
                    secretKeyRef:
                    name: auth0-secrets
                    key: AUTH_AUTH0_CLIENT_SECRET
                - name: AUTH_AUTH0_DOMAIN_ID
                  valueFrom:
                    secretKeyRef:
                    name: auth0-secrets
                    key: AUTH_AUTH0_DOMAIN_ID
                - name: AUTH_SESSION_SECRET
                  valueFrom:
                    secretKeyRef:
                    name: auth0-secrets
                    key: AUTH_SESSION_SECRET
    ```
* Restarted the Deployment and wait for the rollout:
  ```
  oc get deployments -o name | xargs oc rollout restart
  oc get pods --watch
  ```
* Reloaded the UI and verified that Auth0 login
