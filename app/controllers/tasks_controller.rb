class TasksController < ApplicationController
  before_action :login_required
  helper_method :priority_keys, :next_step_status

  def index
    @tasks = current_user.tasks.where.not(status: :deleted).order(created_at: :ASC).page(params[:page] || 1)
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
    return if task.deleted?

    task.update!(status: next_step_status(task.status))
    redirect_to root_url
  end

  def destroy
    task.update!(status: :deleted)
    redirect_to root_url
  end

  private
  def task
    @old_task ||= current_user.tasks.find(params[:id])
  end

  # TODO: change
  def params_with_priority_and_status
    create_params = params.require(:task).permit(:title, :content)
    priority_list = params[:task][:priority]

    create_params.merge(status: :open,
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
end
