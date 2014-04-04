class Idea

	
	attr_reader :title, :description, :id, :likes, :tags, :history, :group
	include Comparable

	def initialize(idea = {})

		@title = idea["title"]
		@description = idea["description"]
		@id = idea["id"]
		@likes = idea["likes"] || 0
		@tags = sanitizeTags(idea["tags"] || [])
		@history = idea["history"] || []
		@group = idea["group"]

	end

	def store

		Idea.store
	end

	def addLike

		@likes += 1
	
	end

	def <=>(otherIdea)

		return (otherIdea.likes <=> @likes) if @group == otherIdea.group
		@group <=> otherIdea.group
	
	end

	def to_h
	
		{
			"title" => @title,
			"description" => @description,
			"likes" => @likes.to_i,
			"tags" => @tags,
			"history" => @history,
			"group" => @group
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

	def withHistory

		@history.dup.insert(0, { "title" => @title, "description" => @description } )
	
	end


end
