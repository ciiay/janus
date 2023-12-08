# Test CloudFlare Zerotrust

Upstream documentation:

 * https://backstage.io/docs/auth/cloudflare/provider/

Known bugs:

* [GitHub issue #779: Newly created backstage identity user entities from signing in with auth providers are not ingested into catalog](https://github.com/janus-idp/backstage-showcase/issues/779) (exists already before)

Preconditions:

* I could only successfully set up the Zero Trust tunnel with a **domain name that is Cloudflare managed**. Ping me if, I can setup a (sub)domain on my Cloudflare domain.

## Test setp

* *Prepare accounts and configuration*
  * Create a [Cloudflare account](https://www.cloudflare.com/)
  * Create a [Zero Trust team](https://one.dash.cloudflare.com/)
    * You can find your team name later unter Zero Trust > Settings > Custom pages
    * You will find there also the full URL, which should be `<teamname>.cloudflareaccess.com`
  * Create a Zero Trust application
    * Access > Application > Add an application
    * Different options might work, but I could setup it just successful with *Self-hosted*
    * Use a subdomain and preregistered domain name
  * Add an Access Group
    * Access > Access Groups > Add a Group
    * I created a default group that matches "Everyone"
  * Create a Tunnel
    * Access > Tunnels > Create a tunnel
* **Start the tunnel**
  I started the tunnel on my local dev machine which has then still access to the public RHDH installation. It should be possible to start the tunnel also directly on the cluster with a Pod or Deployment and a Route.
* **Setup an OCP cluster and RHDH**
  * Start a cluster
  * Create a new project/namespace
  * Apply the rhdh-pull-secret.yaml
  * Install RHDH with helm chart
* **Link the Cloud Flare Tunnel to your RHDH installation**
  * Get the Route URL from the OpenShift Console or with this command
  * The following steps depends on the self-hosted application and preregistered domain name
  * Access > Tunnels > Your Tunnel
  * Click on Configure in the right sidebar and select *Public Hostname*
    * Use a subdomain and registered domain name, like rhdh.your-domain.com
    * As service select https:// and enter the hostname or the RHDH route
    * Create hostname
    * Now edit the new Public Hostname again and expand the "Additional application settings" (both options are only available while editing the entry, not while creating it!)
      * Select TLS and Enable "No TLS Verify"
      * Select HTTP Settings and enter the RHDH hostname into HTTP Host header
    * Save hostname
* **Configure RHDH**
  * Add the auth provider to your app-config.yaml:
    ```yaml
    auth:
    providers:
       cfaccess:
          teamName: TODO_TEAMNAME
       signInPage: cfaccess
    ```
  * The user that uses the login must exist in the catalog. So you need to configure the user like this:
    ```yaml
    catalog:
    rules:
       - allow: [User]
    locations:
       - type: url
          target: TODO
    ```
* Navigate to your new URL and login with a token that Cloud flare will send you via E-Mail.

## Other notes

Test tunnel:

```
docker run --rm -it -p 8080:80 nginx

docker run --rm -it cloudflare/cloudflared:latest tunnel --no-autoupdate run --token ...
```
