Rails.application.routes.draw do
  resources :expert_availabilities
  resources :experts
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }, skip: [:registrations, :passwords]
  root to: 'schedules#new'
  get '/adm', to: 'availabilities#index'
  get '/schedules/search', to: 'schedules#search'

  post '/get_schedules_by_email', to: 'schedules#get_by_email'
  post '/send_schedule_information_by_email', to: 'schedules#send_information_by_email'
  post '/schedule_cancel', to: 'schedules#cancel'


  resources :schedules
  resources :availabilities
  resources :services
  resources :service_points
  resources :users
  resources :profiles

  get '/all_service_points/', to: 'service_points#get_all'
  get '/:service_point_code/get_services_without_expert_by_service_point', to: 'service_points#get_services_without_expert'
  get '/all_services_that_have_service_point/', to: 'services#get_all_that_have_service_point'
  get ':service_id/get_service_points_and_experts_that_have_availability_by_service', to: 'availabilities#get_service_points_and_experts_that_have_availability_by_service'
  get ':service_point_id/:service_id/get_available_dates_by_service_point_and_service', to: 'availabilities#get_available_dates_by_service_point_and_service'
  get ':expert_id/get_available_dates_by_expert', to: 'expert_availabilities#get_available_dates_by_expert'
  get ':date/get_available_times_by_date', to: 'availabilities#get_available_times_by_date'
  get ':date/get_expert_available_times_by_date', to: 'expert_availabilities#get_expert_available_times_by_date'
  get '/novo_sga_attendance_queue_today', to: 'novo_sga#attendance_queue_today'

end

