class BooksController < ApplicationController
  crudify index_attributes: [:author, :title, :pages],
    show_attributes: [
      :author,
      {title: ->(r){ content_tag(:b, r.title) }},
      :pages
    ],
    only: [:edit, :index, :new, :create],
    permit_params: [:title, :author, :pages, :isbn]

end
