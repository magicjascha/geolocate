require 'byebug'
require 'capybara/minitest'
require 'minitest/autorun'
require './geolocate'

class IntegrationTest < Minitest::Test
  include Capybara::DSL
  Capybara.app = Geolocate
  
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def test_form
    page.driver.browser.basic_authorize("foo", "bar")
    visit('/')
    assert page.has_content?('Address')
    has_field?('address')
    assert page.has_button?('Submit')
    fill_in('address', with: 'Checkpoint Charlie')
    click_button('Submit')
    assert_equal(2, page.body.scan(/\d?\d\.\d{7}/).length)   
  end
  
  def test_form_with_non_ascii_characters
    page.driver.browser.basic_authorize("foo", "bar")
    visit('/')
    assert page.has_content?('Address')
    has_field?('address')
    assert page.has_button?('Submit')
    fill_in('address', with: 'Dönerladen, Friedrichstraße')
    click_button('Submit')
    assert_equal(2, page.body.scan(/\d?\d\.\d{7}/).length)   
  end
  
  def test_missing_address
    page.driver.browser.basic_authorize("foo", "bar")
    visit('/')
    assert page.has_content?('Address')
    has_field?('address')
    assert page.has_button?('Submit')
    fill_in('address', with: '')
    click_button('Submit')
    assert_equal("{\"AddressEmpty\":\"Type in your address e.g. 'Checkpoint Charlie' or access query '/locate?address=Checkpoint Charlie'\"}", page.body)
  end
  
  def test_unfindable_address
    page.driver.browser.basic_authorize("foo", "bar")
    visit('/')
    assert page.has_content?('Address')
    has_field?('address')
    assert page.has_button?('Submit')
    fill_in('address', with: 'aaaaaaaaaaaaaaaaaaaaaaaa')
    click_button('Submit')
    assert_equal("{\"NoSearchResultError\":\"Could not find location\"}", page.body)
  end
end