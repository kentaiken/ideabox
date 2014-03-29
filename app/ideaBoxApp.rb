
class IdeaBoxApp < Sinatra::Base

	set :method_override, true
	set :public_folder, Dir.pwd + '/app/assets'

	get '/' do 
		
		@ideas = IdeaStore.findAll.sort
		@tags = TagManager.getUniqueTags(@ideas)
		@idea = Idea.new
		erb :index, :locals => { ideas: @ideas, idea: @idea, tags:  @tags}	

	end

	post '/' do
		
		IdeaStore.addIdea( Idea.new(params[:idea]) )

		redirect to('/')
	end

	get '/:id/edit' do 

		@idea = IdeaStore.findById(params[:id])
		erb :edit, :locals => { idea: @idea, id: params[:id] }
	end

	get '/:id/like' do 

		@idea = IdeaStore.findById(params[:id])
		@idea.addLike
		IdeaStore.update(params[:id], @idea)
		redirect to('/')
	
	end

	get '/ideas/:tagName' do

		@ideas = IdeaStore.findAll.sort
		@ideas = TagManager.ideasWithTagname(params[:tagName], @ideas)

		erb :tag_ideas, :locals => { ideas: @ideas, tagName: params[:tagName] }
	
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
