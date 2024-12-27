ENV['RACK_ENV'] = 'test'

require_relative '../api'
require 'rspec'
require 'rack/test'

RSpec.describe 'Book API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before(:each) do
    $BOOKS.clear
  end

  describe 'GET /books' do
    it 'returns all books' do
      book = { id: 1, title: 'Test Book', author: 'Author', publication_date: '2023-01-01' }
      $BOOKS << book

      get '/books'

      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq({ 'books' => [book.stringify_keys] })
    end
  end

  describe 'POST /books/create' do
    context 'with valid parameters' do
      it 'creates a new book' do
        post '/books/create', { title: 'Test Book', author: 'Author', publication_date: '2023-01-01' }

        expect(last_response).to be_ok
        expect(JSON.parse(last_response.body)['success']).to be true
      end
    end

    context 'with missing required fields' do
      it 'returns an error' do
        post '/books/create', { title: nil, author: nil, publication_date: nil }

        expect(last_response.status).to eq(400)
        expect(JSON.parse(last_response.body)).to include("title cannot be empty", "author cannot be empty", "publication_date cannot be empty")
      end
    end
  end

  describe 'GET /books/:id' do
    it 'returns the book with the given id' do
      book = { id: 1, title: 'Test Book', author: 'Author', publication_date: '2023-01-01' }
      $BOOKS << book

      get "/books/#{book[:id]}"

      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)['book']).to eq(book.stringify_keys)
    end
  end

  describe 'PATCH /books/:id' do
    it 'updates the book with the given id' do
      book = { id: 1, title: 'Test Book', author: 'Author', publication_date: '2023-01-01' }
      $BOOKS << book

      patch "/books/#{book[:id]}", { rating: 5 }

      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)['book']['rating']).to eq("5")
    end

    it 'transitions the status of the book' do
      book = { id: 1, title: 'Test Book', author: 'Author', publication_date: '2023-01-01', status: 'available' }
      $BOOKS << book

      patch "/books/#{book[:id]}", { status: 'checked_out' }

      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)['book']['status']).to eq('checked_out')
    end
  end

  describe 'DELETE /books/:id' do
    it 'deletes the book with the given id' do
      book = { id: 1, title: 'Test Book', author: 'Author', publication_date: '2023-01-01' }
      $BOOKS << book

      delete "/books/#{book[:id]}"

      expect(last_response).to be_ok
      expect(last_response.body).to eq("Book deleted with success")
      expect($BOOKS).to be_empty
    end
  end
end