require 'sinatra'
require 'active_support/all'
require_relative 'book.rb'

PREFIX = 'books'.freeze

get "/#{PREFIX}" do
  body Book.all.to_json
end

post "/#{PREFIX}/create" do
  result = Book.create(params)

  if result[:success]
    status 200
    body result.to_json
  else
    status 400
    body result[:errors].to_json
  end
end

get "/#{PREFIX}/:id" do
  result = Book.find(params[:id]) 

  if result
    status 200
    body result.to_json
  else
    status 500
    body "An error ocurred. Contact our support."
  end
end

patch "/#{PREFIX}/:id" do
  book = $BOOKS.find { |book| book[:id] == params["id"].to_i }
  return status 404 unless book

  result = Book.update(book, params)

  if result
    status 200
    body result.to_json
  else
    status 500
    body "An error ocurred. Contact our support."
  end
end

delete "/#{PREFIX}/:id" do
  result = Book.delete(params[:id]) 

  if result
    status 200
    body "Book deleted with success"
  else
    status 500
    body "An error ocurred. Contact our support."
  end
end
