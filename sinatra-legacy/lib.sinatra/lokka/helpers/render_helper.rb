# frozen_string_literal: true

module Lokka
  module RenderHelper
    def render_detect(*names)
      render_detect_with_options(names)
    end

    def render_detect_with_options(names, options = {})
      ret = ''
      options[:layout] = 'layout'
      names.each do |name|
        out = render_any(name, options)
        unless out.blank?
          ret = out
          break
        end
      end

      return ret if ret.present?
      raise Lokka::NoTemplateError, "Template not found. #{[names.join(', ')]}"
    end

    def partial(name, options = {})
      options[:layout] = false
      render_any(name, options)
    end

    def render_any(name, options = {})
      ret = ''
      templates = settings.supported_templates + settings.supported_stylesheet_templates +
        settings.supported_javascript_templates
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

      send(ext.to_sym, name.to_sym, options) if File.exist?("#{path}.#{ext}")
    end
  end
end
