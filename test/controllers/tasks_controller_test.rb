require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  # without login
  def test_index_without_login
    get '/tasks'

    assert_response :redirect
  end

  def test_create_without_login
    post '/tasks'

    assert_response :redirect
  end

  def test_update_without_login
    put "/tasks/#{ tasks(:task_one).id }"

    assert_response :redirect
  end

  def test_delete_without_login
    delete "/tasks/#{ tasks(:task_one).id }"

    assert_response :redirect
  end

  # login
  def test_index
    sign_in_as_default
    get '/tasks'

    assert_response :success
    assert_equal assigns(:tasks), users(:one).tasks.where.not(status: :deleted).to_a
    assert_template 'tasks/index'
  end

  def test_create
    sign_in_as_default
    before_count = Task.count
    post '/tasks', params: { task: { title: 'test title', content: 'test content', priority: ['urgent','important']} }

    assert_response :redirect
    assert_equal before_count + 1, Task.count
    assert_equal assigns(:task).priority, ['urgent', 'important']
    assert_equal assigns(:task).priority_weight, 150
  end

  def test_update
    sign_in_as_default
    before_status_index = Task::statuses[tasks(:task_one).status]
    put "/tasks/#{ tasks(:task_one).id }"

    assert_response :redirect
    assert_equal Task::statuses[tasks(:task_one).reload.status], before_status_index + 1
  end

  def test_delete
    sign_in_as_default
    before_count = Task.deleted.count
    delete "/tasks/#{ tasks(:task_one).id }"

    assert_response :redirect
    assert_equal before_count + 1, Task.deleted.count
  end
end
