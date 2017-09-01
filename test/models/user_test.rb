require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user=User.new(username: "panos", email: "panos@example.com", password: "password", password_confirmation: "password")
  end

  test "user should be valid" do  
    assert @user.valid?
  end

  test "username should be present" do
    @user.username=" "
    assert_not @user.valid?
  end

  test "username should be unique" do
    @user.save
    user2=User.new(username: "panos", email: "panos@example.com", password: "password", password_confirmation: "password")
    assert_not user2.valid?
  end

  test "name should not be too long" do
    @user.username="a" * 30
    assert_not @user.valid?
  end

  test "name should not be too short" do
    @user.username="aa"
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email=" "
    assert_not @user.valid?
  end

  test "email should be unique" do
    @user.save
    user2=User.new(username: "panos2", email: "panos@example.com", password: "password2", password_confirmation: "password2")
    assert_not user2.valid?
  end

  test "email should have valid format" do
    user2=User.new(username: "panos2", email: "panosexample.com", password: "password2", password_confirmation: "password2")
    assert_not user2.valid?
  end

  test "email should not be too long" do
    @user.email="a" * 106 + "@example.com" 
    assert_not @user.valid?
  end
  
  test "password should be present" do
    @user.password=" "
    assert_not @user.valid?
  end

  test "password should not be too short" do
    @user.password="aa"
    assert_not @user.valid?
  end

  test "password_confirmation should match password" do
    user2=User.new(username: "panos2", email: "panos@example.com", password: "password2", password_confirmation: "password")
    assert_not user2.valid?
  end
end