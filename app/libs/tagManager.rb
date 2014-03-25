class TagManager

	def self.getUniqueTags(ideas)

		uniqueTags = []

		ideas.each do |idea|

			idea.tags.each do |tag|

				uniqueTags << tag if uniqueTags.count(tag) == 0 

			end

		end

		uniqueTags.sort

	end


	def self.ideasWithTagname(tagName, ideas)

		ideas.select do |idea|

			idea.hasTag?(tagName)

		end

	end


end
