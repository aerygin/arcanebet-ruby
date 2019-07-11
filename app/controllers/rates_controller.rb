class RatesController < ApplicationController
  def index
    @rates = Rate.all
  end

  def show
    @rate = Rate.find(params[:id])
  end

  def new
    @rate = Rate.new
  end

  def create
    if (!Rate.find_by_user_id(current_user.id))
      @rate = Rate.new(base_currency: params[:base_currency], target_currency: params[:target_currency], amount: params[:rate][:amount], user_id: current_user.id)
      if (@rate.save)
        redirectToHome
      else
        render 'new'
      end

    else
      redirectToHome
    end
  end

  def edit
    @rate = Rate.find(params[:id])

  end

  def update
    @rate = Rate.find(params[:id])
    @rate.update(base_currency: params[:base_currency], target_currency: params[:target_currency], amount: params[:rate][:amount], user_id: current_user.id)
    redirectToHome
  end

  private def redirectToHome
    path = home_path
    redirect_to path
  end
end
