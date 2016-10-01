class TaskListsController < ApplicationController

  def index
    render_json(TaskList.all)
  end

  def create_or_update
    @task_list = TaskList.find_or_initialize_by(title: task_list_params[:title])
    if @task_list.update_attributes(tasks: task_params)
      render_json(@task_list)
    else
      respond_to do |format|
        format.json do
          render json: @task_list.errors.to_json, status: 400
        end
      end
    end
  end

  protected

  def task_list_params
    params.require(:task_list).permit(:title, tasks: [:title, :completed])
  end

  def task_params
    tasks = params[:task_list] && params[:task_list][:tasks]
    case tasks
    when Array
      tasks.map do |task|
        case task
        when String
          {
            title: task,
            completed: false,
          }
        when ActionController::Parameters
          {
            title: task[:title],
            completed: ActiveRecord::Type::Boolean.new.cast(task[:completed]),
          }
        else
          task
        end
      end.compact
    else
      nil
    end
  end

  def render_json(task_or_tasks)
    respond_to do |format|
      format.json do
        render json: task_or_tasks.to_json(only: [:title, :tasks])
      end
    end
  end

end