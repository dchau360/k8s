#!/bin/bash
###https://blog.kubovy.eu/2020/05/16/retrieve-tls-certificates-from-kubernetes/
#Get all tls keys from a k8s namespace

NAMESPACE="external-tls"

while IFS= read -r SECRET_NAME
do
    # Export TLS Cert
    kubectl get secret -n "${NAMESPACE}" "${SECRET_NAME}" -o json | jq -r '.data."tls.crt"' | base64 -d > "${SECRET_NAME}.crt"

    # Export Private Key
    kubectl get secret -n "${NAMESPACE}" "${SECRET_NAME}" -o json | jq -r '.data."tls.key"' | base64 -d > "${SECRET_NAME}.key"

done < <(kubectl get secret -n "${NAMESPACE}" |  awk 'NR>1 {print $1}')
