module Noodall
  class Routes
    class << self
      def draw(app)
        app.routes.draw do
          root :to => "noodall/nodes#show", :permalink => ['home']
          namespace 'noodall/admin', :as => 'noodall_admin', :path => 'admin' do
            resources :nodes do
              resources :nodes
              member do 
                get :change_template
                get :move_up
                get :move_down
                post :preview
              end
              collection do
                get :tree
              end
            end
          
            resources :assets do
              collection do
                get :images
                get :videos
                get :documents
                post :plupload
                get :pending
                get :tags
              end
              member do
                get :add
              end
            end
            match 'assets/:asset_type/tags' => 'assets#tags', :as => :asset_tags
            match 'components/form/:type' => 'components#form'
            
            resources :forms, :has_many => :form_responses
            
            resources :fields do
              collection do
                get :form
              end
            end
            
            match 'components/form/:type' => 'components#form'

            resources :groups
          end
          
          resources :forms, :has_many => :responses
          
          get "search" => "noodall/nodes#search", :as => :noodall_search
          get "sitemap" => "noodall/nodes#sitemap", :as => :noodall_sitemap
          get "*permalink(.:format)" =>  'noodall/nodes#show', :as => :node_permalink
        end
      end
    end
  end
end
