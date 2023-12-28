FROM python:3.11-slim

RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

COPY archixml2csv.py /usr/src/archixml2csv.py
CMD cp "${ARCHI_MODEL_FILE}" /tmp/archimate.model && \
    (cd /tmp && unzip -o archimate.model model.xml &&  mv model.xml archimate.model || true)  && \
    python /usr/src/archixml2csv.py /tmp/archimate.model
