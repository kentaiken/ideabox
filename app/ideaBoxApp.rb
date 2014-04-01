
class IdeaBoxApp < Sinatra::Base

	set :method_override, true
	set :public_folder, Dir.pwd + '/app/assets'


	before do 

		IdeaStore.upgrade

	end

	get '/' do 

		@ideas = IdeaStore.findAll.sort
		@ideaGroup = IdeaStore.groupedIdeas(@ideas)
		@tags = TagManager.getUniqueTags(@ideas)
		erb :index, :locals => { ideaGroup: @ideaGroup, tags:  @tags}	

	end

	post '/' do
		
		IdeaStore.addIdea( Idea.new(params[:idea]) )

		redirect to('/')
	end

	get '/idea/new' do 
		
		@idea = Idea.new
		@groups = GroupManager.getGroups
		@groups.insert(0, "Default") unless @groups.include? 'Deafult'

		erb :new_idea, :locals => { idea: @idea, groups: @groups }

	end

	get '/group/new' do 

		erb :new_group

	end

	get '/group/:group' do

		@ideaGroup = IdeaStore.groupedIdeas( GroupManager.getIdeasWithGroup(params[:group], IdeaStore.findAll))

		erb :group, :locals => { group: params[:group], ideaGroup: @ideaGroup }
	end

	post '/group/new' do 

		GroupManager.addGroup( params[:groupName] )

		redirect to('/')
	
	end

		

	get '/:id/edit' do 

		@idea = IdeaStore.findById(params[:id])
		@groups = GroupManager.getGroups

		erb :edit, :locals => { idea: @idea, id: params[:id], groups: @groups }
	end

	get '/:id/like' do 

		@idea = IdeaStore.findById(params[:id])
		@idea.addLike
		IdeaStore.update(params[:id], @idea)
		redirect to('/')
	
	end

	get '/ideas/:tagName' do

		@ideas = IdeaStore.findAll
		@ideas = TagManager.ideasWithTagname(params[:tagName], @ideas)
		@ideaGroup = IdeaStore.groupedIdeas(@ideas)

		erb :tag_ideas, :locals => { ideaGroup: @ideaGroup, tagName: params[:tagName] }
	
	end

	get '/idea/:id' do

		@idea = IdeaStore.findById(params[:id])

		erb :idea, :locals => { idea: @idea }

	end


	put '/:id/edit' do
		@originalIdea = IdeaStore.findById(params[:id])
		@idea = Idea.new( params[:idea].merge({ "history" => @originalIdea.withHistory }) )
		IdeaStore.update(params[:id], @idea)
		redirect to('/')
	end

	delete '/:id/delete' do 
		IdeaStore.remove(params[:id])
		redirect to('/')
	end
end
