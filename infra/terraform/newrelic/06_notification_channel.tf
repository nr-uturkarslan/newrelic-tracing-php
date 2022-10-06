############################
### Notification Channel ###
############################

# Email
resource "newrelic_notification_destination" "email" {

  name       = "email"
  account_id = var.NEW_RELIC_ACCOUNT_ID
  type       = "EMAIL"

  property {
    key   = "email"
    value = "${var.notification_email}"
  }
}
#########
