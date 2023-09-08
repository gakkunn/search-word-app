require 'test_helper'

class BlockTest < ActiveSupport::TestCase

  def setup
    @block = blocks(:example_block)
  end

  test "name should be present" do
    @block.name = nil
    assert_not @block.valid?
  end

  test "name should be unique" do
    duplicate_block = @block.dup
    @block.save
    assert_not duplicate_block.valid?
  end

  test "name should not be too long" do
    @block.name = "a" * 31
    assert_not @block.valid?
  end

  test "user_id should be present" do
    @block.user_id = nil
    assert_not @block.valid?
  end
end
