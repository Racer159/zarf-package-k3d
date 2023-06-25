FROM alpine:3.18 AS curl
ARG TARGETARCH
WORKDIR /
RUN apk add curl
RUN curl -L https://github.com/k3s-io/k3s/releases/download/v1.27.2+k3s1/k3s-airgap-images-$TARGETARCH.tar.zst -O

FROM rancher/k3s:v1.27.2-k3s1
ARG TARGETARCH
COPY --from=curl /k3s-airgap-images-$TARGETARCH.tar.zst /var/lib/rancher/k3s/agent/images/k3s-airgap-images-$TARGETARCH.tar.zst
ENTRYPOINT ["/bin/k3s"]
CMD ["agent"]
