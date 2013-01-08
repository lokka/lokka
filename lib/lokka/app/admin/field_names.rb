module Lokka
  class App
    get '/admin/field_names' do
      @field_names = FieldName.
        page(params[:page]).
        per(settings.admin_per_page)
      haml :'admin/field_names/index', layout: :'admin/layout'
    end

    get '/admin/field_names/new' do
      @field_name = FieldName.new
      haml :'admin/field_names/new', layout: :'admin/layout'
    end

    post '/admin/field_names' do
      @field_name = FieldName.new(params[:field_name])
      if @field_name.save
        flash[:notice] = t('field_name_was_successfully_created')
        redirect to('/admin/field_names')
      else
        haml :'admin/field_names/new', layout: :'admin/layout'
      end
    end

    delete '/admin/field_names/:id' do |id|
      field_name = FieldName.find(id) or raise Sinatra::NotFound
      field_name.destroy
      flash[:notice] = t('field_name_was_successfully_deleted')
      redirect to('/admin/field_names')
    end
  end
end
