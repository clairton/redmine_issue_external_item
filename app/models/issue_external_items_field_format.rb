class IssueExternalItemsFieldFormat < Redmine::FieldFormat::List 

      add 'issue_external_items'
      self.searchable_supported = true
      self.form_partial = 'issue_external_item/external_item_config'

	# def possible_values_options(custom_field, object=nil)
	# 	 query = %{
	# 		SELECT 
	# 			handle AS "key", 
	# 			nome AS description 
	# 		FROM
	# 			PD_PRODUTOS 
	# 		WHERE 
	# 			ativo = 'S' 
	# 			and filial = 24
	# 			and codigo NOT IN (443,489,490,492,491,426,427,428,430,429,415,411,412,413,414,421,422,423,425,424,437,438,439,441,440,436,431,432,433,435,434,416,417,418,420,419,446,447,449,448,450,451,453,452,465,464,463,461,460,459,455,458,457,475,472,471,470,469,468,454,467,466,484,483,482,481,480,479,478,477,442,485,486,488,487,503,444,493,494,496,495,497,499,500,502,501)
	# 		ORDER BY
	# 			description
	# 	 }
	# 	 Item.find_by_sql(query).collect { |item| [ item.description, item.key ] }
	# end



	# def edit_tag(view, tag_id, tag_name, custom_value, options={})
 #        select_edit_tag(view, tag_id, tag_name, custom_value, options)
 #      end

 #      # Renders the edit tag as a select and quantity tag
 #      def select_edit_tag(view, tag_id, tag_name, custom_value, options={})
 #        blank_option = ''.html_safe
 #        options_tags = blank_option + view.options_for_select(possible_custom_value_options(custom_value), custom_value.value)
 #        s = view.select_tag(tag_name, options_tags, options.merge(:id => tag_id, :multiple => custom_value.custom_field.multiple?))
 #        s << view.hidden_field_tag(tag_name, '')
 #        s << view.number_field_tag(tag_name + '_quantities', '1123')
 #        s
 #      end

 	def select_edit_tag(view, tag_id, tag_name, custom_value, options={})
 	   view.select_tag(tag_name, '', style: 'display: none')
 	end
end