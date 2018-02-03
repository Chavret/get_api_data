class ProductController < ApplicationController
  def show
    @product = Product.includes(:statistic, :image).find(params[:id])
    respond_to do |format|
      format.html { render "product/show" }
    end
  end

  def index
    @products = Product.all
    respond_to do |format|
      format.html { render "product/index" }
    end
  end
end
