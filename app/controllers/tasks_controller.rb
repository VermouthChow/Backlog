class TasksController < ApplicationController
  before_action :login_required

  def index
    @tasks = current_user.tasks.where.not(status: :deleted).order(created_at: :ASC).page(params[:page] || 1)
  end

  def new
    current_user.tasks.new
  end

  def create
    @task = current_user.tasks.create!(params_with_priority_and_status)
    redirect_to root_url
  end

  def update
    return if task.deleted?

    current_status = Task::statuses[task.status]
    task.update!(status: Task::statuses.key(current_status + 1))
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
    create_params = params.require(:task).permit(:title, :content, :priority)
    priority = create_params[:priority].tr('[]', '').split(',')
    create_params.merge(status: :open, 
                        priority_weight: calculate_priority_weight(priority), 
                        priority: priority)
  end

  def calculate_priority_weight(priority_list)
    priority_list.to_a.inject(0) { |sum, p| sum + Task::PRIORITY[p].to_i }
  end
end
