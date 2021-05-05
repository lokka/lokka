# frozen_string_literal: true

module Lokka
  class App
    namespace '/admin' do
      namespace '/themes' do
        # theme
        get do
          @themes =
            (Dir.glob("#{settings.theme}/*") - Dir.glob("#{settings.theme}/*[-_]mobile")).map do |f|
              title = f.split('/').last
              s = Dir.glob("#{f}/screenshot.*")
              screenshot = s.empty? ? nil : "/#{s.first.split('/')[-3, 3].join('/')}"
              OpenStruct.new(title: title, screenshot: screenshot)
            end
          haml :'admin/themes/index', layout: :'admin/layout'
        end

        put do
          site = Site.first
          site.update_attributes(theme: params[:title])
          flash[:notice] = t('theme_was_successfully_updated')
          redirect to('/admin/themes')
        end
      end

      namespace '/mobile_themes' do
        # mobile_theme
        get do
          @themes =
            Dir.glob("#{settings.theme}/*[-_]mobile").map do |f|
              title = f.split('/').last
              s = Dir.glob("#{f}/screenshot.*")
              screenshot = s.empty? ? nil : "/#{s.first.split('/')[-3, 3].join('/')}"
              OpenStruct.new(title: title, screenshot: screenshot)
            end
          haml :'admin/mobile_themes/index', layout: :'admin/layout'
        end

        put do
          site = Site.first
          site.update_attributes(mobile_theme: params[:title])
          flash[:notice] = t('theme_was_successfully_updated')
          redirect to('/admin/mobile_themes')
        end
      end
    end
  end
end
