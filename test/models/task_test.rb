require 'test_helper'

class TaskTest < ActiveSupport::TestCase

  # find
  def test_find_user_tasks
    user = users(:one)
    tasks = user.tasks

    assert(tasks.count > 0)
  end

  # create
  def test_task_params
    { title: 't-test', 
      content: 'this is a test',
      priority: ['urgent', 'important'],
      priority_weight: 150, 
      status: :closed, 
      user: users(:one) 
    }
  end

  # valid
  def test_create_valid_task
    before_count = Task.count
    task = Task.new(test_task_params)
    task.save!

    assert task.valid?
    assert_equal before_count + 1, Task.count
    assert_equal task.user, users(:one)
  end

  # invalid title
  def test_create_task_with_too_long_title
    task = Task.new(test_task_params.merge(title: 'testtesttesttesttest1'))

    assert_not task.valid?
    assert_equal ["Title is too long (maximum is 20 characters)"], task.errors.full_messages
  end

  def test_create_task_with_no_title
    task = Task.new(test_task_params.merge(title: ''))

    assert_not task.valid?
    assert_equal ["Title can't be blank"], task.errors.full_messages
  end

  # invalid content
  def test_create_task_with_too_long_content
    task = Task.new(test_task_params.merge(content: 'this '*41))

    assert_not task.valid?
    assert_equal ["Content is too long(maximum words: 40)"], task.errors.full_messages
  end

  def test_create_task_with_no_content
    task = Task.new(test_task_params.merge(content: ''))

    assert_not task.valid?
    assert_equal ["Content can't be blank"], task.errors.full_messages
  end 
end
