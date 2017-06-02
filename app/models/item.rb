class Item < ActiveRecord::Base
  #TODO load connection name by configuration
  establish_connection "external_item_#{Rails.env}".to_sym

  attr_accessible :description, :key
end
