FROM alpine:3.8
LABEL maintainer="Mathew Moon < mmoon@quinovas.com >"

RUN mkdir /root/.kube && \
    mkdir -p /root/.helm/plugins && \
    export HELM_HOME=/root/.helm && \
    apk add --no-cache bash nano && \
    apk add --no-cache  --virtual .build \
      git \
      curl \
      py-pip && \
    apk add --no-cache openssl && \
    pip install --no-cache-dir awscli && \
    curl -L https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator >/bin/aws-iam-authenticator && \
    chmod +x /bin/aws-iam-authenticator && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl >/bin/kubectl && \
    chmod +x /bin/kubectl && \
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash && \
    helm plugin install https://github.com/rimusz/helm-tiller && \
    helm init --client-only && \
    rm -rf /root/.cache && \
    apk del --no-cache  .build  && \
    apk add --no-cache python ca-certificates && \
    echo "[ -f ~/.bashrc ] && source ~/.bashrc" >>/etc/profile

COPY tiller.sh /root/.helm/plugins/helm-tiller/scripts/tiller.sh
COPY bashrc /root/.bashrc
ENV PS1="\[\e[0;32m\]$(pwd):\h $\[\e[m\] "

CMD ["/bin/bash"]
