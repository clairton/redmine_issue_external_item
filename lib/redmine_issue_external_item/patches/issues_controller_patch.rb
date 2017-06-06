module RedmineIssueExternalItem
  module Patches
    module IssuesControllerPatch
      extend ActiveSupport::Concern

      included do
        before_filter :include_redmine_issue_external_item_helper
      end

      def include_redmine_issue_external_item_helper
        unless _helpers.included_modules.include? RedmineIssueExternalItemHelper
          self.class.helper RedmineIssueExternalItemHelper
        end
        true
      end
    end
  end
end

unless IssuesController.included_modules.include? RedmineIssueExternalItem::Patches::IssuesControllerPatch
  IssuesController.send :include, RedmineIssueExternalItem::Patches::IssuesControllerPatch
end
