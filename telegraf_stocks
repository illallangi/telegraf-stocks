#!/usr/bin/env python
import re
import argparse
import yfinance
from json import dumps
from telegraf_pyplug.main import print_influxdb_format

# Source: https://djangosnippets.org/snippets/585/
camelcase_to_underscore = (
    lambda str: re.sub("(((?<=[a-z])[A-Z])|([A-Z](?![A-Z]|$)))", "_\\1", str)
    .lower()
    .strip("_")
)


def process(tickers=None, measurement=None, json=False):
    for ticker in tickers.split(','):
        payload = yfinance.Ticker(ticker)
        tags, fields = convert(payload=payload.info)
        line = {"tags": tags, "fields": fields, "measurement": measurement}
        if json:
            print(dumps(line))
        else:
            print_influxdb_format(
                add_timestamp=True,
                **line
            )


def convert(payload=None):
    tags = {}
    fields = {}

    for k in payload:
        v = payload[k]
        converted_key = camelcase_to_underscore(k)
        converted_value = None

        try:
            converted_value = float(v)
        except ValueError:  # All string values become tags
            tags[converted_key] = v
        except TypeError:  # All null values are ignored
            pass
        if converted_value:
            fields[converted_key] = converted_value
    return (tags, fields)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Retrieves stock information from Yahoo Finance and formats them in InfluxDB line format."
    )
    parser.add_argument(
        "--tickers", required=True, help="Comma-separated ticker symbols to check on Yahoo Finance."
    )
    parser.add_argument(
        "--measurement", default="stocks", help="Measurement name for InfluxDB."
    )
    parser.add_argument(
        "--json", action="store_true", help="Output in JSON instead of InfluxDB"
    )
    args = parser.parse_args()
    try:
        process(tickers=args.tickers, measurement=args.measurement, json=args.json)
    except Exception as e:
        print(e)
