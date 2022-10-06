#######################
### Alert Condition ###
#######################

# Alert condition - 
resource "newrelic_alert_condition" "response_time_above_3_sec_at_least_once" {

  name       = "response_time_above_3_sec_at_least_once"
  account_id = var.NEW_RELIC_ACCOUNT_ID
  policy_id  = newrelic_alert_policy.php.id

  type                         = "static"
  enabled                      = true
  violation_time_limit_seconds = 3*24*60*60 // days calculated into seconds

  nrql {
    query = "FROM Span SELECT average(duration) WHERE entity.name = '${var.php_proxy_app_name}' OR entity.name = '${var.php_persistence_app_name}'"
  }

  critical {
    operator              = "above"
    threshold             = 3
    threshold_duration    = 60
    threshold_occurrences = "at_least_once"
  }

  fill_option        = "none"
  aggregation_window = 30
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}
#########
