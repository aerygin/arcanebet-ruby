class PagesController < ApplicationController
  def index

  end

  def home

    puts 'hello'
    if (!Rate.find_by_user_id(current_user.id))
      @no_currency_selected = true
      redirect_to new_rate_path
    else
      @rate = Rate.find_by_user_id(current_user.id)
      access_key = "8cc262808104d5cd0a5915c04a295423"
      #@test = Date.today.strftime("%U").to_i
      @arr = []
      base = @rate.base_currency
      target = @rate.target_currency
=begin
      5.times do
        @hot = HTTParty.get('http://data.fixer.io/api/latest?access_key=' + access_key + '&base=' + base +  '&symbols=' + ',' + target,
                            :headers => {'Content-Type' => 'application/json'})
        @arr.push(@hot)
      end
=end
    end
  end


end
