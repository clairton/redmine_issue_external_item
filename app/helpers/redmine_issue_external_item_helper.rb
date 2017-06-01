module RedmineIssueExternalItemHelper

  # Returns the select tag used to list products
  def external_items_select_tag

    #TODO load query by configuration
    query = %{
		SELECT 
			handle AS "key", 
			nome AS description 
		FROM
			PD_PRODUTOS 
		WHERE 
			ativo = 'S' 
			and filial = 24
			and codigo NOT IN (443,489,490,492,491,426,427,428,430,429,415,411,412,413,414,421,422,423,425,424,437,438,439,441,440,436,431,432,433,435,434,416,417,418,420,419,446,447,449,448,450,451,453,452,465,464,463,461,460,459,455,458,457,475,472,471,470,469,468,454,467,466,484,483,482,481,480,479,478,477,442,485,486,488,487,503,444,493,494,496,495,497,499,500,502,501)
		ORDER BY
			description
    }

    options = content_tag('option')     	

    Item.find_by_sql(query).each do |item|
      options << content_tag('option', item.description, value: item.key)
    end

    select_tag('new_external_item_options', options,  id: 'new_external_item_options', onchange: "fillInputExternalItemInput();")
  end
end
