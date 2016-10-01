require 'rails_helper'

RSpec.describe TaskListsController do

  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  context '#index' do

    def create_task_list(number)
      TaskList.create!(title: "My task list - #{number}", tasks: [
        {
          title: "Groceries",
          completed: false,
        },
        {
          title: "Gym",
          completed: false,
        },
      ])
    end

    it 'produces a list of tasks' do
      create_task_list(1)
      create_task_list(2)
      create_task_list(3)

      get :index

      result = JSON.parse(response.body)

      expect(result).to eq(
                          [
                            {
                              "title" => "My task list - 1",
                              "tasks" => [
                                {
                                  "title" => "Groceries",
                                  "completed" => false
                                },
                                {
                                  "title" => "Gym",
                                  "completed" => false
                                }
                              ]
                            },
                            {
                              "title" => "My task list - 2",
                              "tasks" => [
                                {
                                  "title" => "Groceries",
                                  "completed" => false
                                },
                                {
                                  "title" => "Gym",
                                  "completed" => false
                                }
                              ]
                            },
                            {
                              "title" => "My task list - 3",
                              "tasks" => [
                                {
                                  "title" => "Groceries",
                                  "completed" => false
                                },
                                {
                                  "title" => "Gym",
                                  "completed" => false
                                }
                              ]
                            }
                          ]
                        )
    end

  end

  context '#create_or_update' do

    def do_post(data)
      post :create_or_update, params: {task_list: data}
    end

    it 'is a success' do
      title = "My task list"
      do_post title: title
      expect(response).to be_success

      task_list = TaskList.where(title: title).first

      expect(task_list.title).to eq(title)
      expect(task_list.tasks).to be_blank
    end

    it 'correctly updates the tasks' do
      task_list = TaskList.create!(title: 'My task list')
      tasks = [
        {
          title: "Groceries",
          completed: true,
        },
        {
          title: "Gym",
          completed: true,
        },
      ]

      do_post title: task_list.title, tasks: tasks

      task_list.reload

      expect(response).to be_success
      expect(task_list.tasks).to eq(tasks)
    end

    it 'correctly updates the tasks with array' do
      task_list = TaskList.create!(title: 'My task list')
      tasks = [
        {
          title: "Groceries",
          completed: false,
        },
        {
          title: "Gym",
          completed: false,
        },
      ]

      do_post title: task_list.title, tasks: tasks.map { |task| task[:title] }

      task_list.reload

      expect(response).to be_success
      expect(task_list.tasks).to eq(tasks)
    end

  end

end