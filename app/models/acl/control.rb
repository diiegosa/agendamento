class Acl::Control

  MODULES = [
    {
      path: 'app/controllers',
      namespace: '',
      only: [],
      except: ["application_controller.rb", "home_controller.rb"]
    },
  ]

  def self.all
    controllers = []
    MODULES.each do |control|
      entries = Dir.new("#{Rails.root}/#{control[:path]}").entries
      entries.delete_if{|c| c !~ /_controller/}
      entries = entries.select{|item| control[:only].include?(item)} unless control[:only].empty?
      entries = entries.reject{|item| control[:except].include?(item)} if control[:only].empty? && control[:except].present?
      entries.each do |entry|
        controller = entry_sanitize(control[:namespace], entry)
        controllers.push(controller)
      end
    end
    controllers
  end

  private
    def self.entry_sanitize(namespace, controller_name)
      controller_name = controller_name.camelize.gsub(".rb","")
      "#{namespace}::#{controller_name}".constantize
    end
end