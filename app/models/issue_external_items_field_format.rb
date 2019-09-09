class IssueExternalItemsFieldFormat < Redmine::FieldFormat::List 

	add 'issue_external_items'
	self.form_partial = 'issue_external_item/external_item_config'

 	def select_edit_tag(view, tag_id, tag_name, custom_value, options={})
 	   view.select_tag(tag_name, '', style: 'display: none')
 	end
end