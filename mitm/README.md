# mitm

## Test slow k8s API

I run a local OpenShift Local (CRC) and added this to my `/etc/hosts`:

```
127.0.0.1 delay-1.api.crc.testing
127.0.0.1 delay-2.api.crc.testing
127.0.0.1 delay-3.api.crc.testing
127.0.0.1 delay-4.api.crc.testing
127.0.0.1 delay-5.api.crc.testing
```

After that I used this script to delay the API calls:

```
mitmweb --ssl-insecure -s mitm-delay.py
```
