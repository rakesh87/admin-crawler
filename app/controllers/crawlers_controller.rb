class CrawlersController < ApplicationController

  before_action :authenticate_user!, :load_user
  before_action :set_crawler, only: [:show, :edit, :update, :destroy]
  

  def index
    @crawlers = @user.crawlers
  end

  def show; end

  def new
    @crawler = @user.crawlers.new
  end

  def edit; end

  def create
    @crawler = @user.crawlers.new(crawler_params)

    respond_to do |format|
      if @crawler.save
        format.html { redirect_to user_crawler_url(@user, @crawler), notice: 'Crawler was successfully created.' }
        format.json { render :show, status: :created, location: @crawler }
      else
        format.html { render :new }
        format.json { render json: @crawler.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @crawler.update(crawler_params)
        format.html { redirect_to user_crawler_url(@user, @crawler), notice: 'Crawler was successfully updated.' }
        format.json { render :show, status: :ok, location: @crawler }
      else
        format.html { render :edit }
        format.json { render json: @crawler.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @crawler.destroy
    respond_to do |format|
      format.html { redirect_to user_crawlers_url(@user), notice: 'Crawler was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def crawl
    @crawler = @user.crawlers.find(params[:crawler_id])
    service = SnapdealService.new(product_url: @crawler.url)
    @result_json = service.to_json
    @result = @crawler.register_activity!(@result_json)
    respond_to do |format|
      format.js { }
    end
  end

  private

    def load_user
      @user = User.find(params[:user_id])
    end

    def set_crawler
      @crawler = @user.crawlers.find(params[:id])
    end

    def crawler_params
      params.require(:crawler).permit(:url)
    end
end
