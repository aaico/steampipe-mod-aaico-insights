mod "aaico_insights" {
  # hub metadata
  title         = "AAICO Insights"
  description   = "Dashboards for insights into AAICO infrastructure and resources."
  color         = "#FF9900"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/aws-insights.svg"
  categories    = ["aws", "aaico", "costs"]

  require {
    steampipe = "0.18.0"
    plugin "aws" {
      version = "0.91.0"
    }
  }
}
