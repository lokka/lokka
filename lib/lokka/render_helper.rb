module Lokka
  module RenderHelper
    def render_detect(*names)
      render_detect_with_options(names)
    end

    def render_detect_with_options(names, options = {})
      ret = ''
      names.each do |name|
        out = render_any(name, options)
        unless out.blank?
          ret = out
          break
        end
      end

      if ret.blank?
        raise Lokka::NoTemplateError, "Template not found. #{[names.join(', ')]}"
      else
        ret
      end
    end

    def partial(name, options = {})
      options[:layout] = false
      render_any(name, options)
    end

    def render_any(name, options = {})
      ret = ''
      templates = settings.supported_templates + settings.supported_stylesheet_templates
      templates.each do |ext|
        out = rendering(ext, name, options)
        out.force_encoding(Encoding.default_external) unless out.nil?
        unless out.blank?
          ret = out
          break
        end
      end
      ret
    end

    def rendering(ext, name, options = {})
      options[:views] ||= "#{settings.views}/theme/#{@theme.name}"
      path = "#{options[:views]}/#{name}"

      if File.exist?("#{path}.#{ext}")
        send(ext.to_sym, name.to_sym, options)
      end
    end
  end
end
