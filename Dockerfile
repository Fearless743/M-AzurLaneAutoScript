FROM python:3.7-slim-bullseye

ENV TZ=Asia/Shanghai
ENV FIX_MXNET=0
EXPOSE 22267

# update TZ
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# Install dependencies (include adb from Debian repos to avoid external download)
RUN apt-get update && \
    apt-get install -y git libgomp1 wget unzip pkg-config build-essential adb \
    libavdevice-dev libavfilter-dev libavformat-dev libavcodec-dev libavutil-dev libswscale-dev && \
    apt-get clean

WORKDIR /app/AzurLaneAutoScript

COPY deploy/docker/requirements.txt /tmp/requirements.txt
RUN sed -i '/^av==/d' /tmp/requirements.txt && \
    printf '\nav==8.0.3\n' >> /tmp/requirements.txt && \
    pip install --no-cache-dir -r /tmp/requirements.txt

COPY . /app/AzurLaneAutoScript

RUN cp -f config/deploy.template-docker.yaml config/deploy.yaml && \
    mkdir -p /app/config && \
    cp config/* /app/config/

# clean
RUN rm -rf /tmp/* && \
    rm -r ~/.cache/pip

VOLUME /app/AzurLaneAutoScript/config

RUN chmod +x /app/AzurLaneAutoScript/entrypoint.sh

CMD [ "/app/AzurLaneAutoScript/entrypoint.sh" ]
