module MenuHelper

  def make_menu
    default_icon = 'fa fa-chevron-circle-right'
    [
      { model: 'Usuários', icon: 'fa fa-users', children:
        [
          {model: 'User', action: :index, path: 'users', icon: default_icon, children: []},
          {model: 'Profile', action: :index, path: 'profiles', icon: default_icon, children: []},
        ]
      },
      {model: 'ServicePoint', action: :index, path: 'service_points', icon: default_icon, children: []},
      {model: 'Service', action: :index, path: 'services', icon: default_icon, children: []},
      {model: 'Expert', action: :index, path: 'experts', icon: default_icon, children: []},
      {model: 'ExpertAvailability', action: :index, path: 'expert_availabilities', icon: default_icon, children: []},
      {model: 'Availability', action: :index, path: 'availabilities', icon: default_icon, children: []},
      {model: 'Schedule', action: :index, path: 'schedules', icon: default_icon, children: []},
    ]
  end

end
