class PagesController < ApplicationController
  def root
  end

  def home
  end

  def test
    @testReq = HTTParty.get('http://data.fixer.io/api/latest?access_key = 4c01ec86225d13905757ea6e9c91f66e',
                            :headers => {'Content-Type' => 'application/json'})
  end
end