require 'test_helper'

class CrawlersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @user = users(:one)
    # user = double('user')
    allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
    allow(controller).to receive(:current_user).and_return(@user)
    # sing_in @user 
    @crawler = crawlers(:one)
  end

  test "should get index" do
    get user_crawlers_url(@user)
    assert_response :success
  end

  test "should get new" do
    get new_user_crawler_url
    assert_response :success
  end

  test "should create crawler" do
    assert_difference('Crawler.count') do
      post user_crawlers_url(@user), params: { crawler: { url: @crawler.url } }
    end

    assert_redirected_to user_crawler_url(@user, Crawler.last)
  end

  test "should show crawler" do
    get user_crawler_url(@user, @crawler)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_crawler_url(@user, @crawler)
    assert_response :success
  end

  test "should update crawler" do
    patch user_crawler_url(@user, @crawler), params: { crawler: { url: @crawler.url } }
    assert_redirected_to user_crawler_url(@user, @crawler)
  end

  test "should destroy crawler" do
    assert_difference('Crawler.count', -1) do
      delete user_crawler_url(@user, @crawler)
    end

    assert_redirected_to user_crawlers_url(@user)
  end
end
