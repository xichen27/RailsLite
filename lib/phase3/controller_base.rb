require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
    	form = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    	template = File.read(form)
    	erb_template = ERB.new(template)
			render_content(erb_template.result(binding), "text/html")
    end

  end
end
