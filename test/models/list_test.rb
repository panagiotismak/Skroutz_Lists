require 'test_helper'

class ListTest < ActiveSupport::TestCase
  
  def setup
    @user=User.new(username: "panos", email: "panos@example.com", password: "password", password_confirmation: "password")
    @user.save
    @list=List.new(name: "shoes", user_id: @user.id, private: "false")
  end

  test "list should be valid" do 
    assert @list.valid?
  end

  test "name should be present" do
    @list.name=" "
    assert_not @list.valid?
  end

  test "name should not be too long" do
    @list.name="a" * 60
    assert_not @list.valid?
  end

  test "name should not be too short" do
    @list.name="aa"
    assert_not @list.valid?
  end

  test "user_id should be present" do
    @list=List.new(name: "kitschen")
    assert_not @list.valid?
  end

  test "name should be unique fron user scope" do
    @list.save
    list2=List.new(name: "shoes", user_id: @user.id, private: "true")
    assert_not list2.valid?
  end
end