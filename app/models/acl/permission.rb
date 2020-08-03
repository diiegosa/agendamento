class Acl::Permission < ApplicationRecord
  belongs_to :profile
  belongs_to :app_module
end
