class User


	attr_reader :username, :password, :ideas
	include Ideas

	def initialize(data)
		
		@ideas = data["ideas"] || []
		@username = data["username"] || ""
		@password = data["password"] || ""
		@id = data["id"] || -1

	end
	
	def self.all

		users = []
		store.transaction do |handle|

			handle["users"] ||= []
			handle["users"].each_with_index do |user, user_id|

				ideas = []
				if user["ideas"]
					user["ideas"].each_with_index do |idea, index|
						ideas << Idea.new( idea.merge({"id" => index}) )	
					end
				end
				param = user.dup
				param.delete("ideas")

				users << new(param.merge({"id" => user_id.to_i, "ideas" => ideas}))

			end

		end
		users
	
	end

	def self.store

		YAML::Store.new("./app/db/ideaboxstore")

	end
	
	
	def self.findByName(name)
	
		users = all
		return nil if users.empty?
		users.each do |user|

			return user if user.username == name

		end
	
	end

	def self.add(user)

		store.transaction do |handle|

			handle["users"] ||= []
			handle["users"] << user.to_h
		end

	end

	def to_h

		{
			"username" => @username,
			"password" => @password,
			"ideas" => @ideas
		}
	
	end


	


end

