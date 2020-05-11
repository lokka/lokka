# frozen_string_literal: true

module Lokka
  class App
    namespace '/admin' do
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
    end
  end
end
