class User < ActiveRecord::Base
  # Set many-to-many relation to group
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :lists, dependent: :destroy
  has_many :items, dependent: :destroy
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # Mount uploader for CarrierWave
  mount_uploader :avatar, AvatarUploader

  def is_admin?
    self.role == "admin"
  end
end
