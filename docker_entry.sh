#!/bin/bash

if [ -z ${KUBE_CONFIG} ] && [ ! -f /root/.kube/config ]; then
  echo "Kube config not found."
  exit 1
fi

[ ! -z ${KUBE_CONFIG} ] && echo "${KUBE_CONFIG}"|base64 -d >/root/.kube/config

/bin/bash
