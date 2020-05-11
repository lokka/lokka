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
    end
  end
end
