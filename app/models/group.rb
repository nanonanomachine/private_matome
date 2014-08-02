class Group < ActiveRecord::Base
  before_save { |group| group.privacy = privacy.downcase }
  # Set many-to-many relation to user
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :lists, dependent: :destroy
  has_many :items, dependent: :destroy
  scope :without_secret, -> { find(:all, :conditions => ["privacy != ?", 'secret']) }

  ROLES = ['admin', 'moderator', 'member']

  ROLES.each do |role|
  	self.class_eval <<-eos
  		has_many :#{role.downcase}s, :through => :user_groups, :source => :user,
  				:conditions => "user_groups.role = '#{role}'" do
  					def <<(user)
  						proxy_association.owner.user_groups.create(:role => '#{role}', :user => user)
  					end
  				end
  	eos
  end

  def self.find_not_secret
    where("privacy != ?", "secret")
  end
end
