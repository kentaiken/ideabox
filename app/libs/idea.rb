class Idea

	
	attr_reader :title, :description, :id, :likes, :tags
	include Comparable

	def initialize(idea = {})

		@title = idea["title"]
		@description = idea["description"]
		@id = idea["id"]
		@likes = idea["likes"] || 0
		@tags = sanitizeTags(idea["tags"] || [])

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
			"likes" => @likes.to_i,
			"tags" => @tags
		}
	end

	def sanitizeTags(tags)

		return [] if tags.empty?
		return tags if tags.class == Array

		tags = tags.split(",")

		tags.map do |tag|

			tag.lstrip.rstrip.capitalize

		end
	
	end

	def hasTag?(tagName)

		@tags.include?(tagName)

	end

end
