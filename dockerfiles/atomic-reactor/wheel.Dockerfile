FROM atomic-reactor-wheelbuilder:latest

COPY . /opt/atomic-reactor
WORKDIR /opt/atomic-reactor

RUN python3.8 -m pip install -U pip setuptools wheel && \
    python3.8 -m pip install -r requirements.txt && \
    python3.8 -m pip install .
