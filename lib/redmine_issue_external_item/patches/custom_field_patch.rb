  
module RedmineIssueExternalItem
  module Patches
    module CustomFieldPatch
      extend ActiveSupport::Concern
      CustomField.safe_attributes :query

      included do
        validates :query, presence: true, if: :external_item?
      end

      def external_item?
        field_format == 'issue_external_items'
      end
    end
  end
end

unless CustomField.included_modules.include? RedmineIssueExternalItem::Patches::CustomFieldPatch
  CustomField.send :include, RedmineIssueExternalItem::Patches::CustomFieldPatch
end