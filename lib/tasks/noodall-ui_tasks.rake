namespace :noodall_ui do
  
  desc 'Updates all Asset _keywords arrays to make them searchable'
  task :update_asset_keywords => :environment do
    
    # _update_keywords is called before_save in the Noodall::Search module from noodall-core
    Asset.all.each do |asset|
      asset.save if asset._keywords.empty?
    end
    
  end
  
end
