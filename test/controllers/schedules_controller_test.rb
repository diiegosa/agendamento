require 'test_helper'

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @schedule = schedules(:one)
  end

  test "should get index" do
    get schedules_url
    assert_response :success
  end

  test "should get new" do
    get new_schedule_url
    assert_response :success
  end

  test "should create schedule" do
    assert_difference('Schedule.count') do
      post schedules_url, params: { schedule: { cellphone_number: @schedule.cellphone_number, client_cpf: @schedule.client_cpf, client_name: @schedule.client_name, date: @schedule.date, descrition: @schedule.descrition, email: @schedule.email, property_sequential: @schedule.property_sequential, service_id: @schedule.service_id, service_point_id: @schedule.service_point_id, time: @schedule.time } }
    end

    assert_redirected_to schedule_url(Schedule.last)
  end

  test "should show schedule" do
    get schedule_url(@schedule)
    assert_response :success
  end

  test "should get edit" do
    get edit_schedule_url(@schedule)
    assert_response :success
  end

  test "should update schedule" do
    patch schedule_url(@schedule), params: { schedule: { cellphone_number: @schedule.cellphone_number, client_cpf: @schedule.client_cpf, client_name: @schedule.client_name, date: @schedule.date, descrition: @schedule.descrition, email: @schedule.email, property_sequential: @schedule.property_sequential, service_id: @schedule.service_id, service_point_id: @schedule.service_point_id, time: @schedule.time } }
    assert_redirected_to schedule_url(@schedule)
  end

  test "should destroy schedule" do
    assert_difference('Schedule.count', -1) do
      delete schedule_url(@schedule)
    end

    assert_redirected_to schedules_url
  end
end
