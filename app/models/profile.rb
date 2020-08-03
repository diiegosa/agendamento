class Profile < ApplicationRecord
  before_update :remove_existing_permissions

  has_many :permissions, class_name: 'Acl::Permission', dependent: :delete_all
  accepts_nested_attributes_for :permissions, reject_if: proc { |attributes| attributes['actions'].blank? }

  validates :name, presence: true
  validates :name, uniqueness: true

  def has_action(app_module_id, action)
    permission = self.permissions.where(app_module_id: app_module_id).first
    return permission.present? ? permission.actions.include?(action) : false
  end

  private
    def remove_existing_permissions
      Acl::Permission.where(profile_id: self.id).delete_all
    end
end
