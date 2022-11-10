# Gitlab
> One plattform for your CI/CD, the solution for DevOps.

## Required parameters

When provisioning in GleSYS Cloud, the `bootstrapPassword` parameter needs to be
set. This will set the `GITLAB_ROOT_PASSWORD` env variable during install. Which
is used to set the password for the Gitlab administrator user `root`.

Ex.

`{"cloudconfigparams": {"bootstrapPassword": "A.Very.Secure.Password"}}`
