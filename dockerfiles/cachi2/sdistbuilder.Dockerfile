FROM registry.fedoraproject.org/fedora-minimal:37

RUN microdnf -y install \
    --setopt install_weak_deps=0 \
    --nodocs \
    golang \
    git-core \
    python3 \
    python3-pip \
    python3-devel \
    && microdnf clean all
