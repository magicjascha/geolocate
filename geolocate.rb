# $: << "."
$LOAD_PATH << "."
$LOAD_PATH << "./lib"
require 'sinatra'
require 'net/http'
require 'json'
require 'custom_error'
require 'erb'
require 'cgi'


set :show_exceptions, false
set :raise_errors, true


class Geolocate < Sinatra::Application
  
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'foo' && password == 'bar'
  end

  get '/search' do
    erb :locate
  end

  get '/locate' do
    check_address_query_is_used(params["address"])
    address = CGI.escape(params["address"])
    url = "https://nominatim.openstreetmap.org/?format=json&q=#{address}&format=json&limit=1"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"
    response = http.get(uri.request_uri)
    check_server_answer_is_ok(response)
    check_successful_search(response.body)
    extract_coordinates(response.body)
  end

  def check_address_query_is_used(address)
    raise CustomError::AddressEmpty if address.to_s.empty?
  end
  
  def check_server_answer_is_ok(response)
    raise CustomError::GeoProviderError if response.code != "200"
  end
  
  def check_successful_search(response)
    raise CustomError::NoSearchResultError if response == "[]"
  end

  def extract_coordinates(res)
    data = JSON.parse(res)
    content_type :json
    [data[0]["lat"],data[0]["lon"]].to_json
  end

  error CustomError::AddressEmpty do
    content_type :json
    {AddressEmpty: "Type in your address at /search e.g. 'Checkpoint Charlie' or access query '/locate?address=Checkpoint Charlie'"}.to_json
  end

  error SocketError do
    content_type :json
    {ConnectionError: "Check if your internet-connection is working and try again later"}.to_json
  end

  error CustomError::GeoProviderError do
    content_type :json
    {GeoProviderError: "The provider for geolocations is not answering as expected"}.to_json
  end

  error CustomError::NoSearchResultError do
    content_type :json
    {NoSearchResultError: "Could not find location"}.to_json
  end

  error NoMethodError do
    content_type :json
    {BadResponse: "Sorry. Our geolocation provider is returning nonsense"}.to_json
  end
  run! if app_file == $0
end
  
