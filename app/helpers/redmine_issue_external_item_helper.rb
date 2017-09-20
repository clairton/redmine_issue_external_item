module RedmineIssueExternalItemHelper

  # Returns the select tag used to list products
  def external_items_select_tag(query)

    options = content_tag('option')     	

    Item.find_by_sql(query).each do |item|
      options << content_tag('option', item.description, value: item.key)
    end

    select_tag('new_external_item_options', options,  id: 'new_external_item_options', onchange: "fillInputExternalItemInput();")
  end
end
