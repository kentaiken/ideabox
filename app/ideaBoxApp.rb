
module Routes

	class IdeaGroups < Sinatra::Base
		
		get '/groups/new' do 

			erb :new_group

		end

		get '/groups/:group' do

			@ideasWithGroup = GroupManager.getIdeasWithGroup(params[:group], IdeaStore.findAll)
			@ideaGroup = IdeaStore.groupedIdeas( @ideasWithGroup )
			@group = params[:group]

			erb :group
		end

		post '/groups' do 

			GroupManager.addGroup( params[:groupName] )

			redirect to('/')
		
		end

	end

end


class IdeaBoxApp < Sinatra::Base

	set :method_override, true
	set :public_folder, Dir.pwd + '/app/assets'

	use Routes::IdeaGroups

	before do 

		IdeaStore.upgrade

	end

	get '/' do 

		@ideas = IdeaStore.findAll.sort
		@ideaGroup = IdeaStore.groupedIdeas(@ideas)
		@tags = TagManager.getUniqueTags(@ideas)

		erb :index

	end

	post '/ideas' do
		
		IdeaStore.addIdea( Idea.new(params[:idea]) )

		redirect to('/')
	end


	get '/ideas/new' do 
		
		@idea = Idea.new
		@groups = GroupManager.getGroups
		@groups.insert(0, "Default") unless @groups.include? 'Deafult'

		erb :new_idea

	end

	get '/ideas/search' do

		@ideas = IdeaStore.findIdeas( params[:content] )
		@ideaGroup = IdeaStore.groupedIdeas( @ideas )
		@content = params[:content]

		erb :search_complete

	end
		
	get '/ideas/:id/edit' do 

		@idea = IdeaStore.findById(params[:id])
		@groups = GroupManager.getGroups
		@id = params[:id]

		erb :edit
	end

	get '/ideas/:id/like' do 

		@idea = IdeaStore.findById(params[:id])
		@idea.addLike
		IdeaStore.update(params[:id], @idea)

		redirect to('/')
	
	end

	get %r{/ideas/([a-zA-Z]+)$} do |tagName|

		@ideas = IdeaStore.findAll
		@ideas = TagManager.ideasWithTagname(tagName, @ideas)
		@ideaGroup = IdeaStore.groupedIdeas(@ideas)
		@tagName = tagName

		erb :tag_ideas
	
	end

	get '/ideas/:id' do

		@idea = IdeaStore.findById(params[:id])

		erb :idea

	end


	put 'ideas/:id/edit' do

		@originalIdea = IdeaStore.findById(params[:id])
		@idea = Idea.new( params[:idea].merge({ "history" => @originalIdea.withHistory }) )
		IdeaStore.update(params[:id], @idea)

		redirect to('/')
	end

	delete 'ideas/:id/delete' do 

		IdeaStore.remove(params[:id])

		redirect to('/')
	end

end
