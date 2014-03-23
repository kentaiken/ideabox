class Idea

	
	attr_reader :title, :description

	def initialize(idea = {})
		@title = idea["title"]
		@description = idea["description"]
	end

	def store

		Idea.store
	end

	def to_h
	
		{
			"title" => @title,
			"description" => @description
		}
	end

end
