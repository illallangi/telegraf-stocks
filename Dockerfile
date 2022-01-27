FROM docker.io/library/python:3.9.10

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

COPY ./influxdb.key /etc/apt/trusted.gpg.d/influxdb.asc
COPY ./influxdb.list /etc/apt/sources.list.d/influxdb.list
RUN apt-get update && apt-get install -y --no-install-recommends telegraf && apt-get clean

COPY ./requirements.txt /usr/src/app/requirements.txt
RUN python3 -m pip install -r /usr/src/app/requirements.txt

COPY ./telegraf_stocks /usr/src/app/telegraf_stocks
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

CMD ["/usr/bin/telegraf"]