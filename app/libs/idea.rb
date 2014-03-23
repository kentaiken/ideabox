class Idea

	
	attr_reader :title, :description, :id, :likes
	include Comparable

	def initialize(idea = {})
		@title = idea["title"]
		@description = idea["description"]
		@id = idea["id"]
		@likes = idea["likes"] || 0
	end

	def store

		Idea.store
	end

	def addLike

		@likes += 1
	
	end

	def <=>(otherIdea)

		 otherIdea.likes <=> @likes
	
	end

	def to_h
	
		{
			"title" => @title,
			"description" => @description,
			"likes" => @likes.to_i
		}
	end


end
