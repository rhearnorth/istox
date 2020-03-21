Rails.application.routes.draw do

  get '/reset', to: 'application#reset'
  post '/transfer', to: 'application#transfer'
  get '/get_amounts', to: 'application#get_amounts'
end
