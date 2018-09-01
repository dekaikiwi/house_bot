class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def line
    body = request.body.read

    signature = request.headers['HTTP_X_LINE_SIGNATURE']

    unless client.validate_signature(body, signature)
      raise ActionController::BadRequest.new("Bad Signature")
    end

    events = client.parse_events_from(body)
    events.each do |event|
      line_entity = create_or_find_line_entity(event)
      # case event
      # when Line::Bot::Event::Message
      #   case event.type
      #   when Line::Bot::Event::MessageType::Text
      #     user = JSON.parse(client.get_profile(event['source']['userId']).body)
      #     message = {
      #       type: 'text',
      #       text: "#{user['displayName']} says: #{event.message['text']}"
      #     }
      #     client.reply_message(event['replyToken'], message)
      #   when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
      #     message = {
      #       type: 'text',
      #       text: "You sent a video or photo!"
      #     }
      #     client.reply_message(event['replyToken'], message)
      #     response = client.get_message_content(event.message['id'])
      #     tf = Tempfile.open("content")
      #     tf.write(response.body)
      #     public_url = uploadToS3(tf)
      #
      #     postImageToShuttlerock(public_url)
      #   end
      # end
    end

    render plain: 'OK', status: :ok
  end

  private

  def create_or_find_line_entity(event)
    case event['source']['type']
    when 'user'
      entity = LineUser.find_or_create_by(line_id: event['source']['userId'])
      username = JSON.parse(client.get_profile(event['source']['userId']).body)['displayName']
      entity.update(line_username: username)
    when 'group'
      entity = LineGroup.find_or_create_by(line_id: event['source']['groupId'])
    end

    entity
  end

  def uploadToS3(file)
    bucket = Aws::S3::Bucket.new('scratch.shuttlerock.com')
    object = bucket.object("staff/jono/line_image_test/image-#{Time.now.to_i}.png")
    object.upload_file file, acl: "public-read"

    return object.public_url
  end

  def postImageToShuttlerock(image_url)
    uri = URI("https://api.shuttlerock.com/v2/jono/boards/line-test-board/entries.json")
    res = Net::HTTP.post_form(uri, name: 'Test Upload from Line', image_url: image_url, token: 'dTlOZzdTUkloeFc0amtEUkZSYVNyNG1DWXQ3VUtZN0FHQkRBdGxmVDVVR0ZqZWo4UUhwRXY2bE5rUzZlbFE2dnZBcTF2RkgxT1l0OUVJalIreERXejZVV1RuOEFaK2Jka09NV2tSbGxMYWs9LS0vK09ncE5jQkl1TGlzcWViQzIxVXJnPT0=--21e8e5e45530d1cfcbc0942fd9b7878ddbb3e451')
    puts res.body
  end

  def client
    @client ||= LineService.new.client
  end
end
