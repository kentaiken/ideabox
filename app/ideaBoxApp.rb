
class IdeaBoxApp < Sinatra::Base

	set :method_override, true
	set :public_folder, Dir.pwd + '/app/assets'

	get '/' do 
		
		@ideas = IdeaStore.findAll
		@idea = Idea.new
		erb :index, :locals => { ideas: @ideas, idea: @idea }	

	end

	post '/' do
		
		IdeaStore.addIdea( Idea.new(params[:idea]) )

		redirect to('/')
	end

	get '/:id/edit' do 

		@idea = IdeaStore.findById(params[:id])
		erb :edit, :locals => { idea: @idea, id: params[:id] }
	end


	put '/:id/edit' do
		@idea = params[:idea] 
		IdeaStore.update(params[:id], @idea)
		redirect to('/')
	end

	delete '/:id/delete' do 
		IdeaStore.remove(params[:id])
		redirect to('/')
	end
end
