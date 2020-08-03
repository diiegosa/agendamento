require 'test_helper'

class AppModulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_module = app_modules(:one)
  end

  test "should get index" do
    get app_modules_url
    assert_response :success
  end

  test "should get new" do
    get new_app_module_url
    assert_response :success
  end

  test "should create app_module" do
    assert_difference('AppModule.count') do
      post app_modules_url, params: { app_module: { actions: @app_module.actions, controller: @app_module.controller, name: @app_module.name } }
    end

    assert_redirected_to app_module_url(AppModule.last)
  end

  test "should show app_module" do
    get app_module_url(@app_module)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_module_url(@app_module)
    assert_response :success
  end

  test "should update app_module" do
    patch app_module_url(@app_module), params: { app_module: { actions: @app_module.actions, controller: @app_module.controller, name: @app_module.name } }
    assert_redirected_to app_module_url(@app_module)
  end

  test "should destroy app_module" do
    assert_difference('AppModule.count', -1) do
      delete app_module_url(@app_module)
    end

    assert_redirected_to app_modules_url
  end
end
