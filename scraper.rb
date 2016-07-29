require 'nokogiri'
require 'rest-client'
require 'rspec'

def scrape_page
  response = RestClient.get('http://www.snowbird.com/mountain-report')
  html = Nokogiri::HTML(response)
  results = {}
  results[:base_temp] = html.css('#mountain-base > .condition-value').text
  results[:mid_temp] = html.css('#mountain-mid > .condition-value').text
  results[:peak_temp] = html.css('#mountain-peak > .condition-value').text
  results[:wind_speed_direction] = html.css('#wind-speed > .condition-value').text
  results
end

RSpec.describe do
  it 'checks mountain conditions' do
    expect(RestClient).to receive(:get).with('http://www.snowbird.com/mountain-report').and_return(File.read('./fixture.html'))
    results = scrape_page
    expect(results[:base_temp]).to eql '81°'
    expect(results[:mid_temp]).to eql '75°'
    expect(results[:peak_temp]).to eql '75°'
    expect(results[:wind_speed_direction]).to eql 'NNW @ 10.0 mph'
  end
end
