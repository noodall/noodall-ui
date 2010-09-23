class Nooodall::Admin::AssetsController < Admin::BaseController
  sortable_attributes :created_at, :title, :updated_at
  protect_from_forgery :except => :plupload
  before_filter :readonly

  def index
    options = asset_options(action_name)

    @tags = Asset.tag_cloud options.merge(:limit => 10)
    # By default it gets the top 10 ordered by count lets order these alphbetically
    @tags.sort!{|a,b| a.name <=> b.name }

    @assets = Asset.paginate options.merge( :per_page => (params[:limit] || 15), :page => params[:page], :order => sort_order )

    @readonly = (params[:readonly] || false)
    
    respond_to do |format|
      format.html { render :index }
      format.js { render :index }
      format.xml  { render :xml => @assets }
    end
  end
  alias videos index
  alias documents index

  def show
    @asset = Asset.find(params[:id])
    @readonly = (params[:readonly] || false)
    
    respond_to do |format|
      format.html
      format.js
      format.xml  { render :xml => @asset }
    end
  end

  def tags
    options = { :order => '_id' } # Order by name which is _id in the map/reduce
    if params[:asset_type]
      options.merge!(asset_options(params[:asset_type])) 
      @page_title << " Tags"
    else
      @page_title = "Tags"
    end
    tags = Asset.tag_cloud( options )
    @tag_groups = tags.group_by { |t| t.name.first }
    
    respond_to do |format|
      format.html
      format.js
      format.json  { render :json => tags.map{ |t| t.name } }
    end
  end

  # renders fragment for TinyMCE insert
  def add
    @asset = Asset.find(params[:id])
    # log the asset being used
    if params[:node_id]
      @asset.log_usage(params[:node_id], "Body Copy")
    end
    render :layout => false
  end

  def pending
    @asset = Asset.first(:tags => nil, :offset => params[:offset], :order => "created_at DESC")

    respond_to do |format|
      format.html { render :form }
      format.js { render :form }
      format.xml  { render :xml => @asset }
    end
  end

  def edit
    @asset = Asset.find(params[:id])

    respond_to do |format|
      format.html { render :form }
      format.js { render :form }
      format.xml  { render :xml => @asset }
    end
  end

  def new
    @asset = Asset.new

    respond_to do |format|
      format.html { render :form }
      format.js { render :form }
      format.xml  { render :xml => @asset }
    end
  end

  def create
    logger.debug  request.inspect
    @asset = Asset.new(params[:asset])

    respond_to do |format|
      if @asset.save
        flash[:notice] = 'Asset was successfully created.'
        format.html { redirect_to(admin_assets_type_url(@asset)) }
        format.xml  { render :xml => @asset, :status => :created, :location => @asset }
      else
        format.html { render :action => "form" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  def plupload
    # Get parameters
    chunk = params[:chunk].to_i
    chunks = params[:chunks].to_i
    file_name = params[:name].gsub(/[^\w\._]+/, '') # Clean the fileName for security reasons

    file_path = File.join(Rails.root,'tmp','plupload',file_name)

    storage_dir = File.dirname(file_path)

    # Create tmp dir
    FileUtils.mkdir_p(storage_dir) unless File.exist?(storage_dir)

    if params[:file] #Multipart Upload
      file = File.open(file_path, (chunk == 0 ? "wb" : "ab")) do |f|
        f.write(params[:file].read)
      end
    else
      file = File.open(file_path, (chunk == 0 ? "wb" : "ab")) do |f|
        f.write(request.body.read)
      end
    end
    # If this is the last or only chunk create asset and cleanup temp file
    if chunks == 0 or chunk + 1 == chunks
      asset = Asset.new(:file => File.new(file_path), :description => file_name).save(:validate => false) # Saving without validation as we don't have a description or tags
      File.delete(file_path)
      render :json => {:jsonrpc => "2.0", :result =>  nil, :id => "id"}
    else
      # Return JSON-RPC response
      render :json => {:jsonrpc => "2.0", :result =>  nil, :id => "id"}
    end
  end

  def update
    @asset = Asset.find(params[:id])

    respond_to do |format|
      if @asset.update_attributes(params[:asset])
        format.html do
          flash[:notice] = 'Asset was successfully updated.'
          if params[:pending] and pending_count > 0
            flash[:notice] << " #{pending_count} assets remaining"
             # Go to the next pending asset
            redirect_to(pending_admin_assets_url)
          elsif params[:pending]
            flash[:notice] = 'All assets were successfully updated.'
            redirect_to(admin_assets_type_url(@asset))
          else
            redirect_to(admin_asset_url(@asset))
          end
        end
        format.js { index }
        format.xml  { head :ok }
      else
        format.html { render :action => "form" }
        format.js { render :form }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html do
        flash[:notice] = 'Asset was successfully deleted.'
        if params[:pending] and pending_count > 0
          flash[:notice] << " #{pending_count} assets remaining"
           # Go to the next pending asset
          redirect_to(pending_admin_assets_url)
        else
          flash[:notice] = 'All assets were successfully updated.' if params[:pending]
          redirect_to(admin_assets_type_url(@asset))
        end
      end
      format.xml  { head :ok }
    end
  end

protected
  def asset_options(asset_type)
    options = {}

    case asset_type
    when 'videos'
      @page_title = "Videos"
      options[:file_ext] = 'flv'
    when 'documents'
      @page_title = "Documents"
      options[:file_ext.ne] = 'flv'
      options[:file_mime_type] = { :$not => Asset.image_reg_ex}
    else
      @page_title = "Images"
      options[:file_mime_type] = Asset.image_reg_ex
    end
    if params[:tag]
      options[:tags] = params[:tag]
      @page_title << " tagged '#{params[:tag]}'"
    end
    options
  end

  def admin_assets_type_url(asset)
    if asset.nil? or asset.image?
      admin_assets_url
    elsif asset.video?
      videos_admin_assets_path
    else
      documents_admin_assets_path
    end
  end
  helper_method :admin_assets_type_url

  def pending_count
    @pending_count ||= Asset.count(:tags => nil)
  end
  helper_method :pending_count
  
  def readonly
    @readonly ||= params[:readonly] == 'true'
  end
  helper_method :readonly
end
