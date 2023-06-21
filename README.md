# Deploy HTTP Proxy with Authentication in Openshift

This repository collects information about using and testing the integration of a HTTP proxy in Argo CD repositories synchronization.

## Requirements

- Openshift 4.13+

## Setting Up

- Create the required deployment and service objects

```$bash
oc new-project squid
oc apply -f k8.yaml -n squid
```

- Grant permissions to the default service account

```$bash
oc adm policy add-scc-to-user anyuid -z default -n squid
```

- Check the proxy is running properly

```$bash
oc get pods -n squid
```

## Test Auth Proxy

In order to test the new solution, it is required to execute the following procedure:

- Create the sleep pod

```$bash
oc apply -f k8-test.yaml -n squid
```

- Connect to the sleep pod

```$bash
POD=$(oc get pods --no-headers -o custom-columns=":metadata.name" -n squid -l app.kubernetes.io/name=squid-test)
oc rsh $POD
```

- Execute curl

```$bash
curl -x "http://username:password@squid:3128" "https://docs.bmc.com/docs/PATROLAgentHelixOM/installing-a-squid-proxy-server-973929986.html" -k
```

## Argo CD

- Create the Git repository using proxy

```$bash
oc apply -f secret-repo.yaml -n openshift-gitops
```

- Ensure the repository works properly (E.g. STATUS == Successful)

```$bash
TYPE  NAME  REPO                                              INSECURE  OCI    LFS    CREDS  STATUS      MESSAGE  PROJECT
git         https://github.com/acidonper/jump-app-gitops.git  false     false  false  false  Successful  
```

- Create the Argo CD application

```$bash
oc apply -f argo-app.yaml -n openshift-gitops
```

- Check Argo CD Application is synced fine

## Author

Asier Cidon @RedHat
