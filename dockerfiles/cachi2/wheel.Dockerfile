FROM cachi2-wheelbuilder:latest

COPY . /opt/cachi2
WORKDIR /opt/cachi2

RUN pip3 install -r requirements.txt --no-deps --no-cache-dir --require-hashes && \
    pip3 install --no-cache-dir -e . && \
    rm -rf .git
