# frozen_string_literal: true

class RatesController < ApplicationController
  def index
    @rates = Rate.where(user_id: current_user.id)
  end

  def show
    @rate = Rate.find(params[:id])
    @cac = Rails.cache

    if !current_user.present? || current_user.id != @rate.user_id
      return render 'pages/index.html.erb'
    end
    @result = @rate.calculation
    @result.length > 1? @success = true  : @success = false
    if @success
    @result_collection_for_chart = @rate.generate_collection_for_chart(@result)
    calculate_rates
    end
  end

  def new
    @rate = Rate.new
  end

  def create
      @rate = Rate.new(base_currency: params[:base_currency],
                       target_currency: params[:target_currency],
                       amount: params[:rate][:amount],
                       weeks: params[:rate][:weeks],
                       user_id: current_user.id)
      if @rate.save
        redirect_to_home
      else
        render 'new'
      end
  end

  def edit
    @rate = Rate.find(params[:id])
    if
      @rate.user_id != current_user.id
      redirect_to rates_path
    end
  end

  def update
    @rate = Rate.find(params[:id])
    @rate.update(base_currency: params[:base_currency],
                 target_currency: params[:target_currency],
                 amount: params[:rate][:amount],
                 weeks: params[:rate][:weeks],
                 user_id: current_user.id)
    redirect_to_home
  end

  def destroy
    @rate = Rate.find(params[:id])
    @rate.destroy
    redirect_to_home
  end

  private
  def redirect_to_home
    path = rates_path
    redirect_to path
  end

  def calculate_rates
    @today_rate = @rate.find_today_rate(@result)
    @max_rate = @rate.find_max_rate(@result)
    @min_rate = @rate.find_min_rate(@result)
  end
end
