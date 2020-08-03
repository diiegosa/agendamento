class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :profile

  validates :name, presence: true
  validates :cpf, presence: true

  def is_admin?
    return self.profile.nil? ? false : self.profile.admin
  end

end
