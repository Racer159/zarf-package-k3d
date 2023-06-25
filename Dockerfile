ARG K3S_VERSION

FROM alpine:3.18 AS curl
ARG TARGETARCH
ARG K3S_VERSION
WORKDIR /
RUN apk add curl
RUN curl -L https://github.com/k3s-io/k3s/releases/download/$(echo $K3S_VERSION | sed s/-/\\+/g)/k3s-airgap-images-$TARGETARCH.tar.zst -O

FROM rancher/k3s:$K3S_VERSION
ARG TARGETARCH
COPY --from=curl /k3s-airgap-images-$TARGETARCH.tar.zst /var/lib/rancher/k3s/agent/images/k3s-airgap-images-$TARGETARCH.tar.zst
ENTRYPOINT ["/bin/k3s"]
CMD ["agent"]
