FROM python:3.5.6

RUN apt-get update && \
    apt-get install -y zip && \
    pip install tensorflow==1.13.1 pillow==5.4.1 matplotlib lxml jupyter opencv-python && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -r /root/.cache/pip

RUN curl -L https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip \
        -o /tmp/protoc-3.6.1-linux-x86_64.zip && \
    mkdir -p /tmp/protoc && \
    unzip -q /tmp/protoc-3.6.1-linux-x86_64.zip -d /tmp/protoc && \
    mv /tmp/protoc/bin/protoc /usr/bin/protoc

RUN git clone https://github.com/tensorflow/models.git /opt/tensorflow_models && \
    (cd /opt/tensorflow_models && git reset --hard b36872b66fab34fbf71d22388709de5cd81878b4)
RUN rm -rf /opt/tensorflow_models/.git

RUN (cd /opt/tensorflow_models/research && protoc object_detection/protos/*.proto --python_out=.)

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/opt/project/app:/opt/tensorflow_models/research:/opt/tensorflow_models/research/slim

WORKDIR /opt/project/app

CMD sleep infinity
