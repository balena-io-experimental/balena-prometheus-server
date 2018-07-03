#!/bin/bash

alerts='[
  {
    "labels": {
       "alertname": "mem_threshold_exceeded",
       "instance": "example1"
     },
     "annotations": {
        "info": "The instance example1 is down",
        "summary": "instance example1 is down"
      }
  }
]'

URL="192.168.99.100/alertmanager"

curl -XPOST -d"$alerts" promAdmin:promPass@$URL/api/v1/alerts
