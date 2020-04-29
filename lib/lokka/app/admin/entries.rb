# frozen_string_literal: true

module Lokka
  class App
    namespace '/admin' do
      namespace '/posts' do
        get do
          entries_index Post
        end

        get '/new' do
          entries_new Post
        end

        post do
          entries_create Post
        end

        get '/:id/edit' do |id|
          entries_edit Post, id
        end

        put '/:id' do |id|
          entries_update Post, id
        end

        delete '/:id' do |id|
          entries_destroy Post, id
        end
      end

      namespace '/pages' do
        get do
          entries_index Page
        end

        get '/new' do
          entries_new Page
        end

        post do
          entries_create Page
        end

        get '/:id/edit' do |id|
          entries_edit Page, id
        end

        put '/:id' do |id|
          entries_update Page, id
        end

        delete '/:id' do |id|
          entries_destroy Page, id
        end
      end

      post '/previews' do
        result = handle_entry_preview(params)
        content_type :json
        status result[:status]
        result.to_json
      end
    end

    private

    def entries_index(entry_class)
      @name = entry_class.name.downcase
      @entries = params[:draft] == 'true' ? entry_class.unpublished : entry_class
      @entries = @entries.
                   page(params[:page]).
                   per(settings.admin_per_page)
      haml :'admin/entries/index', layout: :'admin/layout'
    end

    def entries_new(entry_class)
      @name = entry_class.name.downcase
      @entry = entry_class.new(markup: Site.first.default_markup)
      @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t('not_select')])
      @field_names = FieldName.order('name ASC')
      haml :'admin/entries/new', layout: :'admin/layout'
    end

    def entries_edit(entry_class, id)
      @name = entry_class.name.downcase
      (@entry = entry_class.where(id: id).first) || raise(Sinatra::NotFound)
      @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t('not_select')])
      @field_names = FieldName.order('name ASC')
      haml :'admin/entries/edit', layout: :'admin/layout'
    end

    def entries_create(entry_class)
      @name = entry_class.name.downcase
      @entry = entry_class.new(params[@name])
      if params['preview']
        render_preview @entry
      else
        @entry.user = current_user
        if @entry.save
          flash[:notice] = t("#{@name}_was_successfully_created")
          redirect_after_edit(@entry)
        else
          @field_names = FieldName.order('name ASC')
          @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t('not_select')])
          haml :'admin/entries/new', layout: :'admin/layout'
        end
      end
    end

    def entries_update(entry_class, id)
      @name = entry_class.name.downcase
      (@entry = entry_class.where(id: id).first) || raise(Sinatra::NotFound)
      tag_collection = params[@name][:tag_collection]
      @entry.tagged_with(tag_collection) if tag_collection
      if params['preview']
        render_preview entry_class.new(params[@name])
      else
        if @entry.update_attributes(params[@name])
          flash[:notice] = t("#{@name}_was_successfully_updated")
          redirect_after_edit(@entry)
        else
          @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t('not_select')])
          @field_names = FieldName.order('name ASC')
          haml :'admin/entries/edit', layout: :'admin/layout'
        end
      end
    end

    def entries_destroy(entry_class, id)
      name = entry_class.name.downcase
      (entry = entry_class.where(id: id).first) || raise(Sinatra::NotFound)
      entry.destroy
      flash[:notice] = t("#{name}_was_successfully_deleted")
      if entry.draft
        redirect to("/admin/#{name.pluralize}?draft=true")
      else
        redirect to("/admin/#{name.pluralize}")
      end
    end
  end
end
