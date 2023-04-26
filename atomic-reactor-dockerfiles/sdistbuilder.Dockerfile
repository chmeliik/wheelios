FROM quay.io/centos/centos:stream8

RUN dnf -y install \
        gcc \
        make \
        krb5-devel \
        cairo-devel \
        cairo-gobject-devel \
        gobject-introspection-devel \
        libffi-devel \
        openssl-devel \
        popt-devel \
        python38 \
        python38-pip \
        python38-devel \
    && dnf clean all
