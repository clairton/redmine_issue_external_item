module RedmineIssueExternalItemHelper

  # Returns the select tag used to list products
  def external_items_select_tag
    query = "SELECT projects.id as key, projects.name as description FROM projects order by description limit 10"

    options = content_tag('option')

     ActiveRecord::Base.establish_connection('external_item').connection.execute(query).each do |record|
      options << content_tag('option', record['description'], value: record['key'])
    end

    select_tag('new_external_item_options', options,  id: 'new_external_item_options', onchange: "fillInputExternalItemInput();")
  end
end
