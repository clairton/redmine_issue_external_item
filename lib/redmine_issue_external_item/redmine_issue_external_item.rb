require 'redmine_issue_external_item/hooks/views_issues_hook'
require 'redmine_issue_external_item/hooks/model_issue_hook'

Rails.configuration.to_prepare do
  require 'redmine_issue_external_item/patches/issue_patch'
  require 'redmine_issue_external_item/patches/issues_controller_patch'
end

module RedmineIssueExternalItem

  def self.settings()
    Setting[:plugin_redmine_issue_external_item].blank? ? {} : Setting[:plugin_redmine_issue_external_item]
  end

end

