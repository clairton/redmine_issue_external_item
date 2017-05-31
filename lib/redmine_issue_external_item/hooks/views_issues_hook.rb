module RedmineIssueExternalItem
  module Hooks
    class ViewsIssuesHook < Redmine::Hook::ViewListener
      render_on :view_issues_show_description_bottom, partial: 'issues/external_item'
      render_on :view_issues_form_details_bottom, partial: 'issues/external_item_form'
    end
  end
end
