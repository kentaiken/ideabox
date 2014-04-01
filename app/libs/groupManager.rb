class GroupManager

	def self.getIdeasWithGroup(groupName, ideas)


		ret = ideas.select do |idea|
			
			idea.group == groupName

		end

		ret.sort

	end


	def self.addGroup(groupName)

		groupName = sanitize(groupName)

		store.transaction do |handle|

			handle['groups'] ||= []
			handle['groups'] << groupName

		end
	
	end

	def self.getGroups

		store.transaction do |handle|

			handle['groups'] || []

		end
	
	end

	def self.store

		YAML::Store.new("./app/db/ideaboxstore")
	
	end
	
	def self.sanitize(groupName)

		groupName.lstrip.rstrip.capitalize

	end
		

end

