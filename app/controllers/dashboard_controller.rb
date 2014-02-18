class DashboardController < ApplicationController
  include Foreman::Controller::AutoCompleteSearch
  before_filter :prefetch_data, :only => :index

  def index
    respond_to do |format|
      format.html
      format.yaml { render :text => @report.to_yaml }
      format.json
    end
  end

  def puppetdb
    puppetdb_url = case params[:puppetdb]
      when 'd3.v2', 'charts' then "/dashboard#{request.original_fullpath}"
      when 'v3'              then request.original_fullpath
      else ;                      '/dashboard/index.html'
    end
    result = Net::HTTP.get_response('localhost', puppetdb_url, 8080)
    #render error if result. ...
    render :text => result.body
  end

  private

  def prefetch_data
    dashboard = Dashboard.new(params[:search])
    @hosts    = dashboard.hosts
    @report   = dashboard.report
  end

end
