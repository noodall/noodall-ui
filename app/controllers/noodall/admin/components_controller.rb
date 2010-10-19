module Noodall
  module Admin
    class ComponentsController < BaseController

      def form
        render :status => 404 if params[:type].blank?

        # TODO: check for an incorrect object class name passed in
        component_class = params[:type].classify.constantize
        component = component_class.new
        if component.respond_to?(:contents)
          component.contents.reject!{|c| c.asset_id.blank? }
          component.contents << Content.new
        end

        @template_names = @parent.nil? ? Noodall::Node.template_names : @parent.class.template_names

        render :partial => "admin/components/#{component_class.name.underscore.downcase}", :layout => false, :locals => {:component => component, :slot_name => params[:slot]}
      end
    end
  end
end
