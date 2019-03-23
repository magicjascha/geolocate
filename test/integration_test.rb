# $LOAD_PATH << "."
require 'byebug'
require 'capybara/minitest'
require "minitest/autorun"

class IntegrationTest < Minitest::Test
  include Capybara::DSL
  load 'geolocate' unless defined?(Geolocate)
  Capybara.app = Geolocate
  
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def test_form
    page.driver.browser.basic_authorize("foo", "bar")
    visit('/search')
    assert page.has_content?('Address')
    has_field?('address')
    assert page.has_button?('Submit')
    fill_in('address', with: 'Checkpoint Charlie')
    click_button('Submit')
    assert_equal(2, page.body.scan(/\d?\d\.\d{7}/).length)   
  end
  
  def test_form_with_non_ascii_characters
    page.driver.browser.basic_authorize("foo", "bar")
    visit('/search')
    assert page.has_content?('Address')
    has_field?('address')
    assert page.has_button?('Submit')
    fill_in('address', with: 'Dönerladen, Friedrichstraße')
    click_button('Submit')
    assert_equal(2, page.body.scan(/\d?\d\.\d{7}/).length)   
  end
end