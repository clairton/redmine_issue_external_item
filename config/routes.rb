
 match 'external_item/done/:external_item_item_id', to: 'issue_external_items#done', via: [:get, :post]
 match 'external_item/delete/:external_item_item_id', to: 'issue_external_items#delete', via: [:get, :post]
