# frozen_string_literal: true

class RatesController < ApplicationController
  def index
    @rates = Rate.where(user_id: current_user.id)
  end

  def show
    @result = []
    @rate = Rate.find(params[:id])
    access_key = '69a46a5b9ca5029a744162e772a6532f'
    base = @rate.base_currency
    target = @rate.target_currency
    amount = @rate.amount
    weeks  = @rate.weeks
    date = Time.now.utc.to_date
    date_str = date.strftime('%Y-%m-%d')
    weeks.times do
      response = HTTParty.get('http://data.fixer.io/api/' + date_str + '?access_key=' + access_key + '&base=' + base + '&symbols=' + target,
                              :headers => { 'Content-Type' => 'application/json' })

      exchange_rate = response['rates'][target]
      new_amount = amount * exchange_rate
      response = Hash['converted_amount', '%f' % new_amount,
                      'week_nr', date.strftime('%U').to_i,
                      'year', date.strftime('%Y')]
                     .merge(response)
      @result.push(response)
      date = date - 7
      date_str = date.strftime('%Y-%m-%d')

    end

    @result = @result.sort { |b, a| a['date'] <=> b['date'] }
    find_rates(@result, target)
    @result_collection_for_chart = @result.collect {|i| [i["date"], i["rates"][@rate.target_currency]]}
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
      redirect_to edit_rate_path
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

  private
  def find_rates(array, currency)
    @max_rate = array.max_by{ |x| x['rates'][currency] }['rates'][currency]
    @min_rate = array.min_by{ |x| x['rates'][currency] }['rates'][currency]
    @today_rate = array[0]['rates'][currency]
  end

end
