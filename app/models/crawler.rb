class Crawler < ApplicationRecord

	belongs_to :user

	has_many :activities

	validates :url, presence: true

	def register_activity!(data)
		activities.create(
			source_name: data[:vendor],
			fields_data_number: data.count
		)
	end

end
