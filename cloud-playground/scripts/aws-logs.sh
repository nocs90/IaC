#!/bin/bash

DEFAULT_HOME="/home/ubuntu/"

cd $DEFAULT_HOME 

export AWS_ACCESS_KEY_ID={{ access_key_id }}
export AWS_SECRET_ACCESS_KEY={{ access_key_secret }}
export AWS_DEFAULT_REGION={{ aws_region }}

aws logs put-metric-filter --log-group-name kata-web-nginx-4XX/access.log --filter-name kata-web-HTTP4XX --filter-pattern '[host, timestamp, request, statusCode=4*, body_bytes_sent, request_length, user_agent, request_time, request_body]' --metric-transformations  metricName=kata-web-HTTP4XX,metricNamespace=kata-web-nginx-access-log,metricValue=1,defaultValue=0

exit 0