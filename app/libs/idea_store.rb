class IdeaStore


	def self.addIdea(idea)

		store.transaction do |handle|

			handle['ideas'] << idea.to_h

		end
	end

	def self.remove(id)

		store.transaction do |handle|

			handle['ideas'].delete_at(id.to_i)
		end
	end

			

	def self.update(id, data)

		store.transaction do |handle|
			handle['ideas'][id.to_i] = data
		end
	end

	def self.rawIdeas

		store.transaction do |handle|
			handle['ideas'] || []
		end
	
	end

	def self.findAll

		rawIdeas.map do |idea|
			Idea.new(idea)
		end
	
	end

	def self.findById(id)

		findAll[id.to_i]

	end

	def self.store

		puts Dir.pwd 
		@store ||= YAML::Store.new("./app/db/ideaboxstore")
	end

end
