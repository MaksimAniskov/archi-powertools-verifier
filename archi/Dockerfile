FROM alpine:latest as builder
WORKDIR /app
RUN apk add --no-cache \
    wget \
    unzip
ARG ARCHI_VERSION=5.2.0
ARG COARCHI_PLUGIN_VERSION=0.9.2

RUN wget -O archi.tgz -q https://www.archimatetool.com/downloads/archi-5.php?/5.2.0/Archi-Linux64-${ARCHI_VERSION}.tgz && \
    wget -O coarchi.archiplugin -q https://www.archimatetool.com/downloads/coarchi/coArchi_${COARCHI_PLUGIN_VERSION}.archiplugin && \
    tar xf archi.tgz && \
    unzip -n coarchi.archiplugin -d Archi/plugins && \
    rm archi.tgz *.archiplugin

 
FROM ubuntu:24.04
WORKDIR /opt

RUN apt-get update && apt-get install -y xvfb libgtk-3-0 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/Archi /opt/Archi
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-h"]
