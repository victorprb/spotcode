# frozen_string_literal: true

class Api::V1::CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end
end
