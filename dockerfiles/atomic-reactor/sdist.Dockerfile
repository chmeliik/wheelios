FROM atomic-reactor-sdistbuilder:latest

COPY . /opt/atomic-reactor
WORKDIR /opt/atomic-reactor

RUN export CRYPTOGRAPHY_DONT_BUILD_RUST=1 && \
    python3.8 -m pip install --no-build-isolation -U pip setuptools && \
    python3.8 -m pip install -r requirements.txt && \
    python3.8 -m pip install .
