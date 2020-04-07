# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/preview' do
  include_context 'admin login'

  describe 'POST /admin/previews' do
    before do
      post '/admin/previews', params
    end

    context 'With valid params' do
      let(:params) do
        {
          raw_body: "## Dinner\n\n1. Ramen\n2. Udon\n3. Tempura\n",
          markup: 'redcarpet'
        }
      end

      it 'should be success' do
        expect(last_response).to be_successful
        expect(JSON.parse(last_response.body)['body']).to eq(
          <<~HTML
            <h2>Dinner</h2>

            <ol>
            <li>Ramen</li>
            <li>Udon</li>
            <li>Tempura</li>
            </ol>
          HTML
        )
      end
    end
  end
end
