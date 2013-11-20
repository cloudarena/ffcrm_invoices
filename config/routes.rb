Rails.application.routes.draw do

  resources :invoices do 
    collection do
      post :redraw
    end
    member do
    end
  end

end
