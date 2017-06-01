module RedmineIssueExternalItem
  module Patches
    module IssuesControllerPatch
      extend ActiveSupport::Concern

      included do
        alias_method_chain :build_new_issue_from_params, :external_item
      end

      def build_new_issue_from_params_with_external_item
        build_new_issue_from_params_without_external_item
        if User.current.allowed_to?(:edit_external_items, @issue.project)
          @issue.update_external_items(params[:external_items])
        end
      end
    end
  end
end

unless IssuesController.included_modules.include? RedmineIssueExternalItem::Patches::IssuesControllerPatch
  IssuesController.send :include, RedmineIssueExternalItem::Patches::IssuesControllerPatch
end
