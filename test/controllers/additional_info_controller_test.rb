require 'test_helper'

class AdditionalInfoControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get additional_info_new_url
    assert_response :success
  end

  test 'should get create' do
    get additional_info_create_url
    assert_response :success
  end
end
