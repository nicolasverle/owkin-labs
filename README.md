# owkin-labs

Simple terraform projects that will perform the following actions : 

* Create a vpc
* Install an eks cluster inside it with a single managed node group
* Install jupyterhub + nexus helm charts

## Run

Ensure the following binaries are installed before proceeding : 

* aws cli
* terraform
* helm

Export your AWS credentials : 

```
export AWS_ACCESS_KEY_ID="xxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxx"
# ...
```

Then perform terraform init and apply

```
terraform init
terraform apply
```

## Nexus + Jupyterhub connection

The connection is straightforward and takes place in the `jupyterhub-values.yaml` file

```
singleuser:
  extraEnv:
    PIP_INDEX_URL: "http://nexus.nexus.svc.cluster.local:8081/repository/pypi/simple/"
```

It's a simple reference to the nexus pypi repository that NEEDS to be created after the terraform process.
