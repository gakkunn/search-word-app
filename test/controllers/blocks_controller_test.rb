require 'test_helper'

class BlocksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @example_user = users(:example_user)
    @example_block = blocks(:example_block)
  end

  test "should redirect index when not logged in" do
    get blocks_path
    assert_redirected_to new_user_session_path
  end

  test "should get index" do
    sign_in @example_user
    get blocks_path
    assert_response :success
    assert_not_nil assigns(:blocks)
  end

  test "should redirect show when not logged in" do
    get block_path(@example_block)
    assert_redirected_to new_user_session_path
  end

  test "should get show" do
    sign_in @example_user
    get block_path(@example_block)
    assert_response :success
    assert_not_nil assigns(:urlsets)
  end

  test "should redirect new when not logged in" do
    get new_block_path
    assert_redirected_to new_user_session_path
  end

  test "should get new" do
    sign_in @example_user
    get new_block_path
    assert_response :success
  end

  test "should redirect create when not logged in" do
    post blocks_path, params: { block: { name: 'New Block' } }
    assert_redirected_to new_user_session_path
  end

  test "should create block" do
    sign_in @example_user
    assert_difference('Block.count', 1) do
      post blocks_path, params: {
        block: {
          name: 'New Block',
          urlsets_attributes: {
            '0' => {
              name: 'New Urlset Name',
              address: 'http://www.new-example.com'
            }
          }
        }
      }
    end
    assert_redirected_to blocks_path
  end

  test "should redirect edit when not logged in" do
    get edit_block_path(@example_block)
    assert_redirected_to new_user_session_path
  end

  test "should get edit" do
    sign_in @example_user
    get edit_block_path(@example_block)
    assert_response :success
  end

  test "should redirect update when not logged in" do
    patch block_path(@example_block), params: { block: { name: 'Updated Block' } }
    assert_redirected_to new_user_session_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference('Block.count') do
      delete block_path(@example_block)
    end
    assert_redirected_to new_user_session_path
  end

  test "should destroy block" do
    sign_in @example_user
    assert_difference('Block.count', -1) do
      delete block_path(@example_block)
    end
    assert_redirected_to blocks_path
  end
end