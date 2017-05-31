class IssueExternalItem < ActiveRecord::Base
  belongs_to :issue
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_one :comment, as: :commented, dependent: :delete
  acts_as_list

  attr_accessible :is_done, :subject, :key, :quantity
  attr_protected :id

  validates_presence_of :subject, :key, :quantity

  # after_save :recalc_issue_done_ratio

  def editable_by?(usr=User.current)
    usr && (usr.allowed_to?(:edit_external_items, project) || (self.author == usr && usr.allowed_to?(:edit_own_external_items, project)))
  end

  def project
    self.issue.project if self.issue
  end

  def info
    "[#{self.is_done ? 'x' : ' ' }] #{self.subject.strip}"
  end

  def recalc_issue_done_ratio
    return false if (Setting.issue_done_ratio != 'issue_field') || !RedmineIssueExternalItem.settings[:issue_done_ratio]
    done_external_item   = issue.external_item.map { |c| c.is_done ? 1 : 0 }
    issue.done_ratio = (done_external_item.count(1) * 10) / done_external_item.count * 10
    issue.save
  end

end
