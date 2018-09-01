require 'line/bot'

class LineService
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def send_message(target_id, message)
    client.push_message(target_id, message)
  end

  def flex_message_template(options = {})
    flex_type = options[:type] || 'bubble'
    text_fields = options[:text_fields] || []

    body = {
      type: 'box',
      layout: 'horizontal',
      spacing: 'md',
      contents: []
    }

    text_fields.each do |field|
      body['contents'] << field
    end

    {
      type: type,
      body: body
    }
  end
end
