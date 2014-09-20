class List < ActiveRecord::Base
	include PublicActivity::Model
	tracked except: [:update, :destroy], owner: Proc.new{ |controller, model| controller.current_user }
	belongs_to :user
	belongs_to :group
	has_many :items, dependent: :destroy
	mount_uploader :image, EyecatchUploader

	def sort_items
		sort_items = []
		if self.items.count > 0
			first_item = self.items.where(prev_content_id: 0).first
			sort_items << first_item
			id = first_item.id

			while self.items.where(prev_content_id: id).first
				next_item = self.items.where(prev_content_id: id).first
				sort_items << next_item
				id = next_item.id
			end
		end
		sort_items
	end
end
