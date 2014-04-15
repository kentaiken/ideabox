
module Setup

	class Configuration < Sinatra::Base

		configure do 

			set :method_override, true
			set :public_folder, Dir.pwd + '/app/assets'
			enable :sessions

		end
	end

end

module Routes

	class Auth < Sinatra::Base


		helpers do 

			def authenticate(params)

				success = false
				redirect to('/login') unless params[:username] and params[:password]
				user = User.findByName(params[:username])
				if user 
					if user.password == params[:password]
						session[:user] = user
						success = true
					end
				end
				if success
					redirect to('/')
				else
					redirect to('/login')
				end


			end


			def authenticated?
				true if session[:user]
			end

			def fail_auth
			end

	        end	

		before do		

			toThisBlock = ["/login", "/logout", "/signup"].any? do |route|
				route == request.path_info
			end

			redirect to('/login') unless authenticated? or toThisBlock
			              

		end

		get '/login' do

			haml :login

		end

		get '/logout' do

			session[:user] = nil

			redirect to('/')
		end
		
		post '/login' do

			authenticate(params)
			
		end

		get '/signup' do

			haml :signup

		end
		post '/signup' do

			redirect to('/signup') if params[:user][:password] != params[("password-confirm").to_sym]
			user = User.new( params[:user].merge( {"id" => User.all.count} ) ) 
			User.add(user)

		        redirect to('/login')	



	        end

	end

	class IdeaGroups < Sinatra::Base

		before do

			@user = session[:user]
		end
		
		get '/groups/new' do 

			haml :new_group

		end

		get '/groups/:group' do

			@ideasWithGroup = GroupManager.getIdeasWithGroup(params[:group], @user.ideas)
			@ideaGroup = @user.groupedIdeas( @ideasWithGroup )
			@group = params[:group]

			haml :group
		end

		post '/groups' do 

			GroupManager.addGroup( params[:groupName] )

			redirect to('/')
		
		end

	end


	class Ideas < Sinatra::Base


		before do 

			#IdeaStore.upgrade
			@user = session[:user]

		end


		get '/' do 

			@ideas = @user.ideas.sort
			@ideaGroup = @user.groupedIdeas(@ideas)
			@tags = TagManager.getUniqueTags(@ideas)

			haml :index

		end

		post '/ideas' do
			
			@user.addIdea( Idea.new(params[:idea].merge({ "id" => @user.ideas.count}) ))

			redirect to('/')
		end


		get '/ideas/new' do 
			
			@idea = Idea.new
			@groups = GroupManager.getGroups
			@groups.insert(0, "Default") unless @groups.include? 'Default'

			haml :new_idea

		end

		get '/ideas/search' do

			@ideas = @user.findIdeas( params[:content] )
			@ideaGroup = @user.groupedIdeas( @ideas )
			@content = params[:content]

			haml :search_complete

		end
			
		get '/ideas/:id/edit' do 

			@idea = @user.findIdeaById(params[:id])
			@groups = GroupManager.getGroups
			@groups.insert(0, "Default") unless @groups.include? 'Default'
			@id = params[:id]

			haml :edit
		end

		get '/ideas/:id/like' do 

			@idea = @user.findIdeaById(params[:id])
			@user.ideas[params[:id].to_i].addLike
			@user.update(params[:id], @idea)

			redirect to('/')
		
		end

		get %r{/ideas/([a-zA-Z]+)$} do |tagName|

			@ideas = @user.ideas
			@ideas = TagManager.ideasWithTagname(tagName, @ideas)
			@ideaGroup = @user.groupedIdeas(@ideas)
			@tagName = tagName

			haml :tag_ideas
		
		end

		get '/ideas/:id' do

			@idea = @user.findIdeaById(params[:id])

			haml :idea

		end


		put '/ideas/:id/edit' do

			@originalIdea = @user.findIdeaById(params[:id])
			@idea = Idea.new( params[:idea].merge({ "history" => @originalIdea.withHistory }) )
			@user.update(params[:id], @idea)

			redirect to('/')
		end

		delete '/ideas/:id/delete' do 

			@user.removeIdea(params[:id])
			@user = session[:user] = User.findByName(@user.username)

			redirect to('/')
		end

	end
end

class IdeaBoxApp < Sinatra::Base

		
	use Setup::Configuration 
	use Routes::Auth
	use Routes::Ideas
	use Routes::IdeaGroups


end

