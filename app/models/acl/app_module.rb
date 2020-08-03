class Acl::AppModule < ApplicationRecord
  has_many :permissions, :dependent => :destroy
  EXCEPT_CONTROLLER_ACTIONS = [ApplicationHelper]

  def self.verify_modules
    controllers = Acl::Control.all
    add(controllers)
    remove_deleted_modules(controllers)
  end

  private
    # Get except actions
    def self.except_actions
      actions = []
      EXCEPT_CONTROLLER_ACTIONS.each do |controller|
        actions.concat(controller.instance_methods)
      end
      actions
    end

    # Add new modules
    def self.add(controllers)
      controllers.each do |controller|
        app_module = find_or_initialize_by(module: name_sanitize(controller.name))
        actions = controller.action_methods.select { |a| except_actions.exclude? a.to_sym }
        app_module.update_attributes(controller: controller.name, actions: actions.select {
          |a| [:new, :edit].exclude? a.to_sym })
      end
    end

    # Remove deleted modules
    def self.remove_deleted_modules(controllers)
      all.each do |m|
        if controllers.exclude?(m.controller.constantize)
          m.permissions.delete_all
          m.delete
        end
      end
    end

    def self.name_sanitize(name)
      name.gsub!('Controller', '')
      name.singularize
    end
end
