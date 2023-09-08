require 'test_helper'

class UrlsetTest < ActiveSupport::TestCase

  def setup
    @urlset = urlsets(:example_urlset)
  end

  test "name should be present if address is present" do
    @urlset.name = nil
    assert_not @urlset.valid?
  end

  test "address should be present if name is present" do
    @urlset.address = nil
    assert_not @urlset.valid?
  end

  test "address should be valid URL" do
    @urlset.address = "invalidURL"
    assert_not @urlset.valid?
  end
end
