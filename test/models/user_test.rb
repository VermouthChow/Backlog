require 'test_helper'

class UserTest < ActiveSupport::TestCase
 
  # valid
  def test_create_user_with_valid_params
    before_count = User.count
    user = User.new(username: 'test3', password: 'ElleZhou21', password_confirmation: 'ElleZhou21')
    user.save!

    assert user.valid?
    assert_equal user.username, User.last.username
    assert_equal before_count + 1, User.count
  end

  # invalid

  # username

  def test_duplicate_username
    user = User.create!(username: 'test11', password: 'ElleZhou21', password_confirmation: 'ElleZhou21')
    user2 = User.new(username: user.username, password: 'Testttt21', password_confirmation: 'Testttt21')

    assert_not user2.valid?
    assert_equal ["Username has already been taken"], user2.errors.full_messages
  end

  def test_create_user_with_special_characters
    user = User.new(username: 'Test$1', password: 'ElleZhou21', password_confirmation: 'ElleZhou21')

    assert_not user.valid?
  end

  def test_create_user_with_too_long_username
    user = User.new(username: 'testtesttesttest9', password: 'ElleZhou21', password_confirmation: 'ElleZhou21')

    assert_not user.valid?
  end

  def test_create_user_with_too_short_username
    user = User.new(username: 'tes', password: 'ElleZhou21', password_confirmation: 'ElleZhou21')

    assert_not user.valid?
  end

  # password
  def test_create_user_with_different_password_confirmation
    user = User.new(username: 'test4', password: 'ElleZhou21', password_confirmation: 'ElleZhou1')
    
    assert_not user.valid?
  end

  def test_create_user_with_too_long_password
    user = User.new(username: 'test5', password: 'Test1111111111111', password_confirmation: 'Test1111111111111')

    assert_not user.valid?
  end

  def test_create_user_with_too_short_password
    user = User.new(username: 'test6', password: '1Tejsu2', password_confirmation: '1Tejsu2')

    assert_not user.valid?
  end

  def test_create_user_with_invalid_password
    user = User.new(username: 'test7', password: '111111111', password_confirmation: '111111111')
    user1 = User.new(username: 'test8', password: 'eTshsjit', password_confirmation: 'eTshsjit')

    assert_not user.valid?
    assert_not user1.valid?
  end
end
