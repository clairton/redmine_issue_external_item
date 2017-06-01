require File.dirname(__FILE__) + '/../test_helper'

class IssueExternalItemsControllerTest < ActionController::TestCase
  fixtures :projects,
    :users,
    :roles,
    :members,
    :member_roles,
    :issues,
    :issue_statuses,
    :versions,
    :trackers,
    :projects_trackers,
    :issue_categories,
    :enabled_modules,
    :enumerations,
    :attachments,
    :workflows,
    :custom_fields,
    :custom_values,
    :custom_fields_projects,
    :custom_fields_trackers,
    :time_entries,
    :journals,
    :journal_details,
    :queries,
    :issue_external_items

  def setup
    RedmineIssueExternalItem::TestCase.prepare
    Setting.default_language = 'en'
  end

end
