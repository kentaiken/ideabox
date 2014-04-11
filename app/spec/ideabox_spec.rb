require 'yaml/store'
require './app/libs/idea'
require './app/libs/idea_store'
require './app/libs/tagManager'
require './app/libs/groupManager'


describe Idea do

	let (:idea) do

		Idea.new
	
	end


	describe "when it's initialized with no arguments" do
		it "has default values for all attributes" do

			result = idea.instance_variables.all? do |var|
				not idea.instance_variable_get(var).nil? 
			end

			expect(result).to eq(true)
		end
	end
	

end

describe IdeaStore

end


