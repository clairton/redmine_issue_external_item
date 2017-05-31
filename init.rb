require 'redmine'

require 'redmine_issue_external_item/redmine_issue_external_item'

Redmine::Plugin.register :redmine_issue_external_item do
  name 'Redmine Issue External Item Plugin'
  author 'Clairton Rodrigo Heinzen'
  description 'This plugin adds external items to Redmine issues.'
  version '0.1.0'
  url 'https://github.com/clairton/edmine_issue_external_item'
  author_url 'mailto:clairton.rodrigo@gmail.com'

  requires_redmine version_or_higher: '2.0.0'

  settings default: {
    save_log:         false,
    issue_done_ratio: false
  }, partial:       'settings/issue_external_item'

  Redmine::AccessControl.map do |map|
    map.project_module :issue_tracking do |map|
      map.permission :view_external_items, {}
      map.permission :done_external_items, { issue_external_item: :done }
      map.permission :edit_external_items, { issue_external_item: [:delete, :done] }
    end
  end

end
