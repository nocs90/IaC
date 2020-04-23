

resource "aws_cloudwatch_log_stream" "kata-watcher-stream" {
  name           = "kata-web-nginx-access-log-HTTP4XX"
  log_group_name = "${aws_cloudwatch_log_group.kata-watcher-group.name}"
}

resource "aws_cloudwatch_log_metric_filter" "kata-watcher-filter" {
  name           = "kata-web-HTTP4XX"
  pattern        = "[ip, timestamp, method, request, type, http_status=4*, request_lenght, request_size, user_agent, request_time, upstream_response_time, request_body, http_authorization]"
  log_group_name = "${aws_cloudwatch_log_group.kata-watcher-group.name}"

  metric_transformation {
    name      = "EventCount"
    namespace = "kata-web-nginx-access-log"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_group" "kata-watcher-group" {
  
  name = "kata-web-nginx-4XX/access.log"

  tags = {
    Environment = "production"
    Application = "nginx"
  }
}