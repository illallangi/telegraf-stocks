FROM ghcr.io/illallangi/telegraf-base:v0.0.1
ENV INFLUXDB_DATABASE=stocks

COPY ./requirements.txt /usr/src/app/requirements.txt
RUN python3 -m pip install --no-cache-dir -r /usr/src/app/requirements.txt

COPY telegraf.conf /etc/telegraf/telegraf.conf

COPY ./telegraf_stocks.py /usr/src/app/telegraf_stocks.py

