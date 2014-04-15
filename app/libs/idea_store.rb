module Ideas

	def addIdea(idea)

		@ideas << idea
		store.transaction do |handle|

			handle["users"][@id]["ideas"] ||= []
			handle["users"][@id]["ideas"] << idea.to_h

		end
	end

	def removeIdea(id)
		
		store.transaction do |handle|

			handle["users"][@id]["ideas"].delete_at(id.to_i)
		end
	end

			

	def update(id, data)

		@ideas[id.to_i] = data
		store.transaction do |handle|
			handle["users"][@id]["ideas"][id.to_i] = data.to_h
		end
	end


	def findIdeaById(id)

		@ideas[id.to_i]

	end

	def groupedIdeas(ideas)

		ret = {}

		ideas.each do |idea|

			ret[idea.group] = ret[idea.group] || []
			ret[idea.group] << idea

		end

		ret

	end

	def findIdeas( content )


		ideas = @ideas.sort
		ideas.select do |idea|
			
			idea.title.include? content or idea.description.include? content
		end

	end

	def store

		YAML::Store.new("./app/db/ideaboxstore")
	end
	
	#The code in here changes all the current data to the most recent structure.
	#This should only be done one time.
	def self.upgrade
	
	end


end
