FROM alpine:3.8
LABEL maintainer="Mathew Moon < mmoon@quinovas.com >"

RUN mkdir /root/.kube

RUN echo $DEV_KUBE_CONFIG | base64 -d >/root/.kube/config && \
    cat /root/.kube/config && \
    mkdir -p /root/.helm/plugins && \
    apk add --no-cache bash && \
    export HELM_HOME=/root/.helm && \
    apk add --no-cache  \
      go \
      git \
      build-base \
      curl \
      py-pip && \
    apk add --no-cache openssl && \
    go get -u github.com/cloudflare/cfssl/cmd/... && \
    go get -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator && \
    mv /root/go/bin/* /bin/ && \
    pip install --no-cache-dir awscli && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /bin && \
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash && \
    helm plugin install https://github.com/rimusz/helm-tiller && \
    helm init --client-only && \
    rm -rf /usr/local/go && \
    rm -rf /root/go && \
    rm -rf /root/.cache && \
    rm -rf /root/.go && \
    apk del --no-cache  \
      go \
      git \
      build-base \
      curl \
      py-pip && \
    apk add --no-cache python && \
    apk add --no-cache groff

CMD ["/bin/bash"]
