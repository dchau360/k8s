#!/bin/bash
#Get all tls keys from a k8s namespace

NAMESPACE="external-tls"
mkdir ~/tls-certs

while IFS= read -r SECRET_NAME
do
    # Export TLS Cert
    kubectl get secret -n "${NAMESPACE}" "${SECRET_NAME}" -o json | jq -r '.data."tls.crt"' | base64 -d > ~/tls-certs/"${SECRET_NAME}.crt"

    # Export Private Key
    kubectl get secret -n "${NAMESPACE}" "${SECRET_NAME}" -o json | jq -r '.data."tls.key"' | base64 -d > ~/tls-certs/"${SECRET_NAME}.key"

done < <(kubectl get secret -n "${NAMESPACE}" |  awk 'NR>1 {print $1}')
