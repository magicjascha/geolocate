require './geolocate'
require 'test/unit'
require 'net/http'
require 'json'
require 'rack/test'
require 'byebug'
require 'capybara/minitest'
require 'minitest/autorun'


class ApiTest < Minitest::Test
  include Rack::Test::Methods
  
  def app
    Geolocate
  end
  def test_false_credentials
    address = "Checkpoint+Charlie"
    url = "/locate?address="+address
    basic_authorize 'false', 'credentials'
    response = get url
    #access denied, responsebody is empty
    assert_equal 'Basic realm="Protected Area"', response.headers["WWW-Authenticate"]
    assert_equal "", response.body
  end
  
  def test_api_with_valid_address
    address = "Checkpoint+Charlie"
    url = "/locate?address="+address
    basic_authorize "foo", "bar"
    response = get url
    #test format of response
    res_parsed = JSON.parse(response.body)
    assert(!!res_parsed[0].match(/\d?\d\.\d{7}/))
    assert(!!res_parsed[1].match(/\d?\d\.\d{7}/))
  end
  
  def test_api_with_non_ascii_characters_address
    address = CGI.escape("Dönerladen, Friedrichstraße")
    url = "/locate?address="+address
    basic_authorize "foo", "bar"
    response = get url      
    #test format of response
    res_parsed = JSON.parse(response.body)
    assert(!!res_parsed[0].match(/\d?\d\.\d{7}/))
    assert(!!res_parsed[1].match(/\d?\d\.\d{7}/))
  end
  
  def test_api_with_empty_address_query
    url = "/locate?address="
    basic_authorize "foo", "bar"
    response = get url    
    #test format
    res_parsed = JSON.parse(response.body)
    assert_equal({"AddressEmpty"=>"Type in your address e.g. 'Checkpoint Charlie' or access query '/locate?address=Checkpoint Charlie'"}, res_parsed)
  end
  
  def test_api_with_unfindable_address
    address = "aaaaaaaaaaaaaaaa"
    url = "/locate?address="+address
    basic_authorize "foo", "bar"
    response = get url    
    #test format
    res_parsed = JSON.parse(response.body)
    assert_equal({"NoSearchResultError"=>"Could not find location"}, res_parsed)
  end
end