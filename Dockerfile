FROM docker.io/library/python:3.9.10

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    XDG_CONFIG_HOME=/config

RUN curl -s https://repos.influxdata.com/influxdb.key | apt-key add -
RUN echo "deb https://repos.influxdata.com/debian buster stable" > /etc/apt/sources.list.d/influxdb.list
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      telegraf=1.22.4-1 \
    && \
    rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt /usr/src/app/requirements.txt
RUN python3 -m pip install --no-cache-dir -r /usr/src/app/requirements.txt

ADD entrypoint.sh /entrypoint.sh
ADD telegraf.conf /etc/telegraf/telegraf.conf

COPY ./telegraf_stocks /usr/src/app/telegraf_stocks

ENTRYPOINT ["/entrypoint.sh"]
RUN chmod +x /entrypoint.sh
CMD ["/usr/bin/telegraf"]