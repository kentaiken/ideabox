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
			handle['ideas'][id.to_i] = data.to_h
		end
	end

	def self.rawIdeas

		store.transaction do |handle|
			handle['ideas'] || []
		end
	
	end

	def self.findAll

		ideas = []
		rawIdeas.each_with_index do |idea, index|
			ideas << Idea.new( idea.merge({"id" => index}) )
		end
		ideas
	
	end

	def self.findById(id)

		findAll[id.to_i]

	end

	def self.store

		@store ||= YAML::Store.new("./app/db/ideaboxstore")
	end

	def self.groupedIdeas(ideas)

		ret = {}

		ideas.each do |idea|

			ret[idea.group] = ret[idea.group] || []
			ret[idea.group] << idea

		end

		ret


	end
	
	#The code in here changes all the current data to the most recent structure.
	#This should only be done one time.
	def self.upgrade
	
	end


end
