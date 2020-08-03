class Acl::Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.is_admin?
      can :manage, :all
    else
      user.profile.permissions.each do |p|
        if defined? p.app_module.module
          can p.actions.collect{|action| action.to_sym}, p.app_module.module.constantize
        end
      end
    end
  end
end
