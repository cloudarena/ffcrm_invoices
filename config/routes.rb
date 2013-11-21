Rails.application.routes.draw do

  resources :invoices do 
    collection do
      post :redraw
      post :auto_complete
    end
    member do
      put :attach
      post :discard
    end
  end

end
