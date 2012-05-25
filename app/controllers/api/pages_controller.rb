class Api::PagesController < ApplicationController

  private

  def respond_with_pages
    respond_to do |format|
      format.json { render json: @pages }
      format.xml { render xml: @pages }
    end
  end

  public

  # GET /api/pages.json
  # GET /api/pages.xml
  def index
    @pages = Page.all
    respond_with_pages
  end

  # GET /api/pages/published.json
  # GET /api/pages/published.xml
  def published
    @pages = Page.where(["published_on < ?", Time.now.utc])
    @pages = @pages.order("published_on DESC")
    respond_with_pages
  end

  # GET /api/pages/unpublished.json
  # GET /api/pages/unpublished.xml
  def unpublished
    @pages = Page.where(["published_on is ? or published_on > ?", nil, Time.now.utc])
    @pages = @pages.order("published_on DESC")
    respond_with_pages
  end

  # GET /api/pages/1.json
  # GET /api/pages/1.xml
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.json { render json: @page }
      format.xml { render xml: @page }
    end
  end

  # GET /api/pages/new.json
  # GET /api/pages/new.xml
  def new
    @page = Page.new
    accessible_attributes = Page._accessible_attributes[:default].to_a

    @res = @page.attributes.delete_if do |attr|
      !accessible_attributes.include?(attr)
    end

    respond_to do |format|
      format.json { render json: @page }
      format.xml { render xml: @page }
    end
  end

  # POST /api/pages.json
  # POST /api/pages.xml
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.json { render json: @page, status: :created, location: @page }
        format.xml { render xml: @page, status: :created, location: @page }
      else
        format.json { render json: @page.errors, status: :unprocessable_entity }
        format.xml { render xml: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /api/pages/1/total_words.json
  # GET /api/pages/1/total_words.xml
  def total_words
    @page = Page.find(params[:page_id])

    respond_to do |format|
      format.json { render json: {total_words: @page.total_words} }
      format.xml { render xml: {total_words: @page.total_words} }
    end
  end

  # POST /pages/1/publish.xml
  # POST /pages/1/publish.json
  def publish
    @page = Page.find(params[:page_id])

    respond_to do |format|
      if @page.update_attributes({published_on: Time.now.utc})
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.json { render json: @page.errors, status: :unprocessable_entity }
        format.xml { render xml: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /api/pages/1.json
  # PUT /api/pages/1.xml
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.json { render json: @page.errors, status: :unprocessable_entity }
        format.xml { render xml: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/pages/1.json
  # DELETE /api/pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end
