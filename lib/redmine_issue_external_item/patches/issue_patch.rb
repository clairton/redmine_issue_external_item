require_dependency 'issue'

module RedmineIssueExternalItem
  module Patches

    module IssuePatch

      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method_chain :copy_from, :external_item
          has_many :external_item, class_name: 'IssueExternalItem', dependent: :destroy
        end

      end

      module InstanceMethods
        def copy_from_with_external_item(arg, options={})
          copy_from_without_external_item(arg, options)
          issue          = arg.is_a?(Issue) ? arg : Issue.visible.find(arg)
          self.external_item = issue.external_item.map { |cl| cl.dup }
          self.external_item.each do |object|
            object.is_done = nil
          end
          self
        end

        def update_external_items(external_items, create_journal = false)
          external_items ||= []

          old_external_item = external_item.collect(&:info).join(', ')

          external_item.destroy_all
          external_item << external_items.uniq.collect do |cli|
            IssueExternalItem.new(is_done: cli[:is_done], subject: cli[:subject], key: cli[:key], quantity: cli[:quantity])
          end

          new_external_item = external_item.collect(&:info).join(', ')

          if current_journal && create_journal && (new_external_item != old_external_item)
            current_journal.details << JournalDetail.new(
              property:  'attr',
              prop_key:  'external_item',
              old_value: old_external_item,
              value:     new_external_item)
          end
        end

      end

    end

  end
end


unless Issue.included_modules.include?(RedmineIssueExternalItem::Patches::IssuePatch)
  Issue.send(:include, RedmineIssueExternalItem::Patches::IssuePatch)
end
