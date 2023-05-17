dashboard "account_report" {

  title = "Cost Overview"
  tags = {
    type     = "AWS"
    category = "Billing"
  }

  container {

    card {
      title = "Cost this month"
      query = query.cost_this_month
      width = 3
    }

    card {
      title = "Last month"
      query = query.cost_last_month
      width = 3
    }

  }

  #   table {
  #     title = "Costs per Service"
  #     width = 8
  #     query = query.costs_per_service
  #   }

}

query "cost_this_month" {
  sql = <<-EOQ
    select
        sum(net_unblended_cost_amount) :: numeric :: money as "Costs"
    from
        aws_cost_usage
    where
        granularity = 'MONTHLY' and to_char(period_start, 'Mon-YY') = to_char(now(), 'Mon-YY')
        and dimension_type_1 = 'LINKED_ACCOUNT'
        and dimension_type_2 = 'SERVICE'
  EOQ
}

query "cost_last_month" {
  sql = <<-EOQ
    select
        sum(net_unblended_cost_amount) :: numeric :: money as "Costs"
    from
        aws_cost_usage
    where
        granularity = 'MONTHLY' and to_char(period_start, 'Mon-YY') = to_char(now() - interval '1' month, 'Mon-YY')
        and dimension_type_1 = 'LINKED_ACCOUNT'
        and dimension_type_2 = 'SERVICE'
  EOQ
}

query "costs_per_service" {
  sql = <<-EOQ
    select
        service as "Service",
        usage_type as "Type",
        to_char(period_start, 'Mon-YY') as "Month",
        blended_cost_amount :: numeric :: money as "Blended Cost",
        unblended_cost_amount :: numeric :: money as "Unblended Cost",
        amortized_cost_amount :: numeric :: money as "Amortized Cost",
        net_unblended_cost_amount :: numeric :: money as "Net Unblended Cost",
        net_amortized_cost_amount :: numeric :: money as "Net Amortized Cost"
    from
        aws_cost_by_service_usage_type_monthly
    order by
        period_start,
        net_unblended_cost_amount desc;
    EOQ
}
