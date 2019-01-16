FROM alpine:3.8
LABEL maintainer="Mathew Moon < mmoon@quinovas.com >"

RUN apk add --no-cache go && \
    apk add --no-cache git && \
    apk add --no-cache bash && \
    apk add --no-cache build-base && \
    go get -u github.com/cloudflare/cfssl/cmd/... && \
    go get -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator && \
    mv /root/go/bin/* /bin/ && \
    apk del --no-cache go && \
    apk del --no-cache git && \
    apk del --no-cache build-base && \
    rm -rf /usr/local/go && \
    rm -rf /root/go && \
    rm -rf /root/.cache && \
    rm -rf /root/.go

RUN mkdir /root/.kube

COPY config /root/.kube/config

RUN mkdir -p /root/.helm/plugins && \
    export HELM_HOME=/root/.helm

RUN apk add --no-cache curl && \
    apk add --no-cache git && \
    apk add --no-cache py-pip && \
    apk add --no-cache openssl && \
    pip install awscli && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /bin && \
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash && \
    helm plugin install https://github.com/rimusz/helm-tiller && \
    helm init --client-only

CMD ["/bin/bash"]
