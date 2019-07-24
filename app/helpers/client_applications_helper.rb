module ClientApplicationsHelper
  def catalog_table_content
    dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")

    table_name = 'contact_management'
    params = {
        table_name: table_name,
        # projection_expression: "url",
        # filter_expression: "url = test1.com"
    }

    result = dynamodb.scan(params)[:items] #.sort_by!{|k| k["created_at"]}.reverse!

  end
end
