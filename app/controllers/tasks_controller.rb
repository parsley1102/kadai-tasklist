class TasksController < ApplicationController
  
  before_action :require_user_logged_in, only: [:index, :show]
  before_action :correct_user, only: [:destroy, :update]
  
  def index
    if logged_in?
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    end
  end

  def show
    if logged_in?
      @task = Task.find(params[:id])
    end
  end

  def new
    if logged_in?
      @task = Task.new
    end
  end

  def create
    if logged_in?
      @task = current_user.tasks.build(task_params)
      if @task.save
        flash[:success] = 'Taskを投稿しました。'
        redirect_to root_url
      else
        @tasks = current_user.tasks.order(id: :desc).page(params[:page])
        flash.now[:danger] = 'Taskの投稿に失敗しました。'
        render 'tasks/new'
      end
    end
  end

  def edit
    
    if logged_in?
      @task = Task.find(params[:id])
    end
  end

  def update
    if logged_in?
      @task = Task.find(params[:id])
  
      if @task.update(task_params)
        flash[:success] = 'Taskは正常に更新されました'
        redirect_to @task
      else
        flash.now[:danger] = 'Taskは更新されませんでした'
        render :edit
      end
    end
  end

  def destroy
    if logged_in?
      @task = Task.find(params[:id])
      @task.destroy
    
    
      flash[:success] = 'Taskは正常に削除されました'
      redirect_to root_url
    end
  end
  
  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @tasks
      redirect_to root_url
    end
  end
  
end
