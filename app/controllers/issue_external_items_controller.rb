class IssueExternalItemsController < ApplicationController

  before_action :find_external_item

  def search()
    query = "SELECT projects.id as key, projects.name as description FROM projects";

    if params[:description]
       query << " where lower(projects.name) like lower('%#{params[:description]}%' )"
    end
    query << " order by description limit 10"

    @items = []

    ActiveRecord::Base.connection.execute(query).each do |record|
      @items << {key: record['key'], description: record['description']}
    end

    respond_to do |format|
      format.html { render json: @items.to_json}
      format.json { render json: @items.to_json }
    end
  end

  def done
    (render_403; return false) unless User.current.allowed_to?(:done_external_items, @external_item_item.issue.project)

    old_external_item_item      = @external_item_item.dup
    @external_item_item.is_done = !@external_item_item.is_done

    if @external_item_item.save
      if RedmineIssueExternalItem.settings[:save_log] && old_external_item_item.info != @external_item_item.info
        journal = Journal.new(journalized: @external_item_item.issue, user: User.current)
        journal.details << JournalDetail.new(
          property: 'attr',
          prop_key: 'external_item',
          # old_value: old_external_item_item.info,
          value:    @external_item_item.info)
        journal.save
      end

      if (Setting.issue_done_ratio == 'issue_field') && RedmineIssueExternalItem.settings[:issue_done_ratio]
        done_external_item                   = @external_item_item.issue.external_item.map { |c| c.is_done ? 1 : 0 }
        @external_item_item.issue.done_ratio = (done_external_item.count(1) * 10) / done_external_item.count * 10
        @external_item_item.issue.save
      end
    end
    respond_to do |format|
      format.js
      format.html { redirect_to :back }
    end

  end

  def delete
    (render_403; return false) unless User.current.allowed_to?(:edit_external_items, @external_item_item.issue.project)

    @external_item_item.delete
    respond_to do |format|
      format.js do
        render :update do |page|
          page["external_item_item_#{@external_item_item.id}"].visual_effect :fade
        end
      end
      format.html { redirect_to :back }
    end

  end

  private

  def find_external_item
      if params[:external_item_id]
        @external_item_item = IssueExternalItem.find(params[:external_item_id])
        @project        = @external_item_item.issue.project
      end
   end

end
