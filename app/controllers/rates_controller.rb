# frozen_string_literal: true

class RatesController < ApplicationController
  def index
    @rates = Rate.where(user_id: current_user.id)
  end

  def show
    @rate = Rate.find(params[:id])
    if !current_user.present? || current_user.id != @rate.user_id
      return render 'pages/index.html.erb'
    end

    @result = ::Fixer::Service.new(@rate).calculate
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
    if !current_user.present? || current_user.id != @rate.user_id
      render 'pages/index.html.erb'
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

  def redirect_to_home
    path = rates_path
    redirect_to path
  end
end
