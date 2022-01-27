FROM docker.io/library/python:3.9.10

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

WORKDIR /usr/src/app

COPY ./requirements.txt /usr/src/app/requirements.txt
RUN python -m pip install -r requirements.txt

ADD telegraf_stocks /usr/src/app

ENTRYPOINT [ "python", "./telegraf_stocks" ]
