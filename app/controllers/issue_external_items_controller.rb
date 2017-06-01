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

  def delete
    (render_403; return false) unless User.current.allowed_to?(:edit_external_items, @external_item.issue.project)

    @external_item.delete
    respond_to do |format|
      format.js do
        render :update do |page|
          page["external_item_#{@external_item.id}"].visual_effect :fade
        end
      end
      format.html { redirect_to :back }
    end

  end

  private

  def find_external_item
      if params[:external_item_id]
        @external_item = IssueExternalItem.find(params[:external_item_id])
        @project        = @external_item.issue.project
      end
   end

end
