FROM registry.ci.openshift.org/ocp/builder:rhel-9-golang-1.21-openshift-4.17 AS builder
WORKDIR /go/src/github.com/openshift/cluster-api-provider-baremetal
COPY . .
RUN go build --mod=vendor -o machine-controller-manager ./cmd/manager

FROM registry.ci.openshift.org/ocp/4.17:base-rhel9
#RUN INSTALL_PKGS=" \
#      libvirt-libs openssh-clients genisoimage \
#      " && \
#    yum install -y $INSTALL_PKGS && \
#    rpm -V $INSTALL_PKGS && \
#    yum clean all
COPY --from=builder /go/src/github.com/openshift/cluster-api-provider-baremetal/machine-controller-manager /
COPY --from=builder /go/src/github.com/openshift/cluster-api-provider-baremetal/manifests /manifests

LABEL io.openshift.release.operator=true
