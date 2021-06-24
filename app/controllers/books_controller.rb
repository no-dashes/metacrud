class BooksController < ApplicationController
  crudify index_attributes: [:author, :title, :pages],
    only: [:edit, :index, :new, :create],
    permit_params: [:title, :author, :pages, :isbn]
end
