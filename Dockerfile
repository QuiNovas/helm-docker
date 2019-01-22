FROM alpine:3.8
LABEL maintainer="Mathew Moon < mmoon@quinovas.com >"

RUN mkdir /root/.kube && \
    mkdir -p /root/.helm/plugins && \
    export HELM_HOME=/root/.helm && \
    apk add --no-cache  --virtual .build \
      git \
      curl \
      bash \
      py-pip && \
    apk add --no-cache openssl && \
    pip install --no-cache-dir awscli && \
    curl -L https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator >aws-iam-authenticator && \
    chmod +x aws-iam-authenticator && \
    mv aws-iam-authenticator /bin && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl >kubectl && \
    chmod +x kubectl && \
    mv kubectl /bin && \
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash && \
    helm plugin install https://github.com/rimusz/helm-tiller && \
    helm init --client-only && \
    rm -rf /root/.cache && \
    apk del --no-cache  .build  && \
    apk add --no-cache python
#    apk add --no-cache groff

CMD ["/bin/sh"]
