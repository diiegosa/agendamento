require 'test_helper'

class ServicePointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service_point = service_points(:one)
  end

  test "should get index" do
    get service_points_url
    assert_response :success
  end

  test "should get new" do
    get new_service_point_url
    assert_response :success
  end

  test "should create service_point" do
    assert_difference('ServicePoint.count') do
      post service_points_url, params: { service_point: { acronym: @service_point.acronym, cep: @service_point.cep, city: @service_point.city, name: @service_point.name, neighborhood: @service_point.neighborhood, number: @service_point.number, public_area: @service_point.public_area } }
    end

    assert_redirected_to service_point_url(ServicePoint.last)
  end

  test "should show service_point" do
    get service_point_url(@service_point)
    assert_response :success
  end

  test "should get edit" do
    get edit_service_point_url(@service_point)
    assert_response :success
  end

  test "should update service_point" do
    patch service_point_url(@service_point), params: { service_point: { acronym: @service_point.acronym, cep: @service_point.cep, city: @service_point.city, name: @service_point.name, neighborhood: @service_point.neighborhood, number: @service_point.number, public_area: @service_point.public_area } }
    assert_redirected_to service_point_url(@service_point)
  end

  test "should destroy service_point" do
    assert_difference('ServicePoint.count', -1) do
      delete service_point_url(@service_point)
    end

    assert_redirected_to service_points_url
  end
end
