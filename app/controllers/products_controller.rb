require 'rubygems'
require 'etsy'

class ProductsController < ApplicationController
  # GET /products
  # GET /products.json
  def index
  Etsy.environment = :sandbox
  Etsy.api_key = 'jxlkilc231xneorjddg9qqgl' #'2EI2INXXOMKNES5WY4RATNGR'
  Etsy.api_secret = 'zwfyoucn6o' #'DVP5OZYDO4'
  Etsy.callback_url = authorize_products_url
  request = Etsy.request_token
  session[:request_token]  = request.token
  session[:request_secret] = request.secret
  redirect_to Etsy.verification_url
  
  #redirect Etsy.verification_url  
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  def authorize
  access_token = Etsy.access_token(
    session[:request_token],
    session[:request_secret],
    params[:oauth_verifier]
  )
  
  access = {:access_token => access_token.token, :access_secret => access_token.secret}
  @user = Etsy.myself(access_token.token, access_token.secret)
  
  render 'show'
  end

  
end
