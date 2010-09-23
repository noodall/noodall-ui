module ComponentsHelper


  def component_row(*args)
    node = args.shift
  raise ActiveRecord::RecordNotFound if node.nil?
    components = args.map { |slot_code| node.send(slot_code) }

    # render each slot in the row
    args.map do |slot_code|
      index = args.index(slot_code)
      component = components[index] 
      
      additional_classes = []
      additional_classes << slot_code.split("_").shift unless slot_code.split("_").shift.nil?
      additional_classes << 'penultimate' if slot_code == args[args.size - 2]
      additional_classes << 'last' if args.last == slot_code
      additional_classes << 'first' if args.first == slot_code
      
      # pass a flag to the view to add an expanded html class
      component(node, slot_code, ( components[index + 1].nil? && index < (args.size - 1) ), additional_classes.join(' ')).to_s
    end
  end
  
  def component(node, slot_code, expand = false, additional_classes = '')
    component = node.send(slot_code)
    # Add an empty blank to fill in
    if component.respond_to?(:contents)
      component.contents.reject!{|c| c.asset_id.blank? }
      component.contents << Content.new
    end
    
    additional_classes = []
    additional_classes << slot_code.split("_").shift unless slot_code.split("_").shift.nil?

    render :partial => "components/#{component.class.name.underscore}", :locals => { :slot_code => slot_code, :component => component, :expand => expand, :additional_classes => additional_classes } unless component.nil?
  end

  def response_setup(form)
    # collect the default values together
    defaults = {}
    form.fields.collect{|f| defaults[f.underscored_name.to_sym] = f.default } unless form.nil? || form.fields.nil?

    Response.new(defaults)
  end

  def promo_size(component, slot_code, expand = false)
    case slot_code
    when /^main/
      hero_size
    when /^wide/
      component.node.is_a?( PageB ) ? '700x250#' : '460x150#'
    else # Should be small
      if expand
        '440x300#'
      else
        '220x300#'
      end
    end
  end

  def hero_size
    case @node
    when Home
      '700x400#'
    when CoursePage
      '700x250#'
    when StudyLandingPage, LandingPage
      '940x250#'
    else
      node_has_nav? ? '700x250#' : '940x250#'
    end
  end

  def asset_thumbnail_from_url(url)
    uid = url.gsub('/static/', '').gsub(/\.fl[v|4]$/, '') #Get UID from url
    logger.debug "ASET UID #{uid}"
    a = Asset.find_by_file_uid(uid)
    image_tag(a.url('220x125#',  :jpg), :alt => a.description, :class => "video-thumb") unless a.nil?
  end
end
