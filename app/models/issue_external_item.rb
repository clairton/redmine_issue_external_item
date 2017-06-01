class IssueExternalItem < ActiveRecord::Base
  belongs_to :issue
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_one :comment, as: :commented, dependent: :delete
  acts_as_list

  attr_accessible :description, :key, :quantity
  attr_protected :id

  validates_presence_of :description, :key, :quantity

  def editable_by?(usr=User.current)
    usr && (usr.allowed_to?(:edit_external_items, project) || (self.author == usr && usr.allowed_to?(:edit_own_external_items, project)))
  end

  def project
    self.issue.project if self.issue
  end

  def info
    "#{self.key} - #{self.description} - #{self.quantity}"
  end
end
