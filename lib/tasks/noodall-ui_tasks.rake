namespace :noodall_ui do
  
  desc 'Updates all Asset _keywords arrays to make them searchable'
  task :update_asset_keywords => :environment do
    
    # _update_keywords is called before_save in the Noodall::Search module from noodall-core
    (1..Asset.paginate.total_pages).each do |page|
      assets = Asset.paginate(page: page)
      puts "Last asset in set id: #{assets.last.id}"

      assets.each do |asset|
        asset.save
      end

    end
    
  end
  
end
