module Noodall::ComponentsHelper


  def component_row(*args)
    node = args.shift
  raise ActiveRecord::RecordNotFound if node.nil?
    components = args.map { |slot_code| node.send(slot_code) }

    # render each slot in the row
    args.map do |slot_code|
      index = args.index(slot_code)
      component = components[index]

      #Build a string here to stop ruby 1.9 outputting a normal printed array
      additional_classes = ""
      additional_classes << ' ' + slot_code.split("_").shift + ' ' unless slot_code.split("_").shift.nil?
      additional_classes << ' penultimate ' if slot_code == args[args.size - 2]
      additional_classes << ' last ' if args.last == slot_code
      additional_classes << ' first ' if args.first == slot_code

      # pass a flag to the view to add an expanded html class
      component(node, slot_code, ( components[index + 1].nil? && index < (args.size - 1) ), additional_classes).to_s
    end.join.html_safe
  end

  def component(node, slot_code, expand = false, additional_classes = '')
    component = node.send(slot_code)

    #Use a string here to stop ruby 1.9 outputting a normal printed array
    additional_classes = ""
    additional_classes << slot_code.split("_").shift unless slot_code.split("_").shift.nil?

    render :partial => "components/#{component.class.name.underscore}", :locals => { :slot_code => slot_code, :component => component, :expand => expand, :additional_classes => additional_classes } unless component.nil?
  end
end
