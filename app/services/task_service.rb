class TaskService
  def people
    @people ||= LineUser.task_users.pluck(:line_username).shuffle
  end

  def tasks_for_today
    day = current_date.strftime("%A").downcase
    Task.where("'#{day}' = ANY (days)")
  end

  def task_matrix
    tasks_for_today.map.with_index do |task, index|
      { assignee: people[index % (people.length)] , task: task}
    end
  end

  def daily_update_alt_text
    text = "#{formatted_date} 当番情報\n"

    task_matrix.each do |row|
      text += "#{row[:task].title}\n"
      text +=  "#{row[:assignee]}\n"
    end

    text
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

    task_matrix.each do |row|

      task_row = {
        type: "text",
        text: row[:task].title,
        size: "md",
        align: "center",
        color: "#000000",
        weight: 'bold'
      }

      assignee_row = {
        type: "text",
        text: row[:assignee],
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
  end

  private

  def formatted_date
    current_date.strftime('%Y年%-m月%-d日(%a)')
  end

  def current_date
    Time.now.in_time_zone("Tokyo")
  end
end
