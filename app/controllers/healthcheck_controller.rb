class HealthcheckController < ApplicationController
  skip_before_action :basic_auth

  def index
    render plain: 'OK', status: 200
  end
end
