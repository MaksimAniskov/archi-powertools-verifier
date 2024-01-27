FROM python:3.11-slim

RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

COPY archixml2csv.py /usr/src/archixml2csv.py
COPY wrapper.sh wrapper.sh
ENTRYPOINT ["/wrapper.sh"]
