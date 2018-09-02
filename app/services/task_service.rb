class TaskService
  def people
    @people ||= LineUser.task_users.shuffle
  end

  def tasks_for_today
    day = task_date.strftime("%A").downcase
    Task.where("'#{day}' = ANY (days)")
  end

  def task_matrix
    @matrix ||= tasks_for_today.map.with_index do |task, index|
      { assignee: people[index % (people.length)] , task: task }
    end
  end

  def daily_update_alt_text
    text = "#{formatted_date} 当番情報\n"

    daily_tasks.each do |row|
      text += "#{row.task.title}\n"
      text +=  "#{row.line_user.line_username}\n"
    end

    text
  end

  def daily_tasks
    return DailyTask.today unless DailyTask.today.empty?

    tasks_for_today.each_with_index do |task, index|
      user = people[index % (people.length)]

      user.daily_tasks.create(task: task)
    end

    DailyTask.today
  end

  def send_individual_update
    people.each do |person|

      contents = person.daily_tasks.today.map do |daily_task|
        {
          type: 'bubble',
          hero: {
            type: 'image',
            url: 'https://source.unsplash.com/800x400/?cleaning',
            size: 'full',
            aspectMode: 'cover',
            aspectRatio: '20:13',
          },
          body: {
            type: 'box',
            layout: 'vertical',
            contents: [
              {
                type: 'text',
                text: daily_task.task.title,
                size: 'xl',
                weight: 'bold',
              },
              {
                type: 'text',
                text: daily_task.task.formatted_description,
                wrap: true,
                size: 'md',
              }
            ]
          }
        }


      end

      flex_message = {
        type: 'flex', altText: daily_update_alt_text,
        contents: {
          type: 'carousel',
          contents: contents,
        }
      }

      puts LineService.new.send_message(person.line_id, flex_message).body
    end
  end

  def send_daily_update
    body = {
      type: 'box',
      layout: 'vertical',
      spacing: 'md',
      contents: []
    }

    body[:contents] << {
      type: "text",
      text: "#{formatted_date} 当番情報",
      size: "lg",
      align: "center",
      color: "#000000",
      weight: 'bold'
    }

    body[:contents] << { type: 'separator' }

    daily_tasks.each do |task|

      task_row = {
        type: "text",
        text: task.task.title,
        size: "md",
        align: "center",
        color: "#000000",
        weight: 'bold'
      }

      assignee_row = {
        type: "text",
        text: task.line_user.line_username,
        size: "md",
        align: "center",
        color: "#0000ee"
      }

      body[:contents] << task_row
      body[:contents] << assignee_row
    end

    flex_message = {
      type: 'flex', altText: daily_update_alt_text,
      contents: {
        type: 'bubble',
        hero: {
          type: 'image',
          url: 'https://source.unsplash.com/800x400/?cleaning',
          size: 'full',
          aspectMode: 'cover',
          aspectRatio: '20:13',

        },
        body: body
      }
    }

    LineGroup.task_groups.find_each do |group|
      LineService.new.send_message(group.line_id, flex_message)
    end

    send_individual_update
  end

  private

  def formatted_date
    task_date.strftime('%Y年%-m月%-d日(%a)')
  end

  def task_date
    Time.now.in_time_zone("Tokyo") + 1.day
  end
end
