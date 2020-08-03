require 'test_helper'

class ExpertAvailabilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expert_availability = expert_availabilities(:one)
  end

  test "should get index" do
    get expert_availabilities_url
    assert_response :success
  end

  test "should get new" do
    get new_expert_availability_url
    assert_response :success
  end

  test "should create expert_availability" do
    assert_difference('ExpertAvailability.count') do
      post expert_availabilities_url, params: { expert_availability: { date: @expert_availability.date, expert_id: @expert_availability.expert_id, shift: @expert_availability.shift } }
    end

    assert_redirected_to expert_availability_url(ExpertAvailability.last)
  end

  test "should show expert_availability" do
    get expert_availability_url(@expert_availability)
    assert_response :success
  end

  test "should get edit" do
    get edit_expert_availability_url(@expert_availability)
    assert_response :success
  end

  test "should update expert_availability" do
    patch expert_availability_url(@expert_availability), params: { expert_availability: { date: @expert_availability.date, expert_id: @expert_availability.expert_id, shift: @expert_availability.shift } }
    assert_redirected_to expert_availability_url(@expert_availability)
  end

  test "should destroy expert_availability" do
    assert_difference('ExpertAvailability.count', -1) do
      delete expert_availability_url(@expert_availability)
    end

    assert_redirected_to expert_availabilities_url
  end
end
