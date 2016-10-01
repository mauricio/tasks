Rails.application.routes.draw do

  resources :task_lists, only: :index do
    collection do
      post 'create_or_update'
    end
  end

end
