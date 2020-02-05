class TasksController < ApplicationController
  before_action :login_required
  helper_method :priority_keys, :next_step_status

  def index
    @tasks = tasks.order(created_at: :ASC).page(params[:page] || 1)
    @show_closed_switch = show_closed_boolean
  end

  def new
    current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(params_with_priority_and_status)
    flash[:notice] = @task.errors.to_a unless @task.save
    redirect_to root_url
  end

  def update
    task.update!(status: next_step_status(task.status)) unless task.deleted?
    redirect_to root_url
  end

  def destroy
    task.update!(status: :deleted)
    redirect_to root_url
  end

  private

  def tasks
    old_tasks = current_user.tasks.where.not(status: :deleted)
    old_tasks = old_tasks.where.not(status: :closed) unless show_closed_boolean
    old_tasks
  end

  def task
    @old_task ||= current_user.tasks.where.not(status: :deleted).find(params[:id])
  end

  def params_with_priority_and_status
    priority_list = params[:task][:priority]
    params.require(:task).permit(:title, :content).merge(status: :open,
                                                         priority_weight: calculate_priority_weight(priority_list),
                                                         priority: priority_list)
  end

  def calculate_priority_weight(priority_list)
    priority_list.to_a.inject(0) { |sum, p| sum + Task::PRIORITY[p].to_i }
  end

  def priority_keys
    ::Task::PRIORITY.keys 
  end

  def next_step_status(current_status)
    Task::statuses.key(Task::statuses[current_status] + 1)
  end

  def show_closed_boolean
    ::ActiveModel::Type::Boolean.new.cast(params[:show_closed])
  end
end