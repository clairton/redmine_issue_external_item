require_dependency 'issue'

module RedmineIssueExternalItem
  module Patches
    module IssuePatch

      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method_chain :copy_from, :external_items
          has_many :external_items, class_name: 'IssueExternalItem', dependent: :destroy
        end
      end

      module InstanceMethods
        def copy_from_with_external_items(arg, options={})
          copy_from_without_external_items(arg, options)
          issue = arg.is_a?(Issue) ? arg : Issue.visible.find(arg)
          self.external_items = issue.external_items.map { |cl| cl.dup }
          self
        end

        def update_external_items(external_items_new, create_journal = false)
          external_items_new ||= []

          old_external_items = external_items.collect(&:info).join(', ')

          external_items.destroy_all
          external_items << external_items_new.uniq.collect do |cli|
            IssueExternalItem.new(description: cli[:description], key: cli[:key], quantity: cli[:quantity])
          end

          new_external_items = external_items.collect(&:info).join(', ')

          if current_journal && create_journal && (new_external_items != old_external_items)
            current_journal.details << JournalDetail.new(
              property:  'attr',
              prop_key:  'external_item',
              old_value: old_external_items,
              value:     new_external_items)
          end
        end
      end

    end

  end
end


unless Issue.included_modules.include?(RedmineIssueExternalItem::Patches::IssuePatch)
  Issue.send(:include, RedmineIssueExternalItem::Patches::IssuePatch)
end
