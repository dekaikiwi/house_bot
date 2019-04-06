class CentralSportsService

  CLUBS_TO_SEARCH = [145]

  attr_accessor :club_id

  def initialize(club_id)
    @club_id = club_id
  end

  def schedule_message
    "#{club_schedule.club.name}\n#{schedule_date.strftime('%m/%d (%A)')}\n=========\n\n#{schedule_list}"
  end

  def schedule_list
    list_str = ""

    # puts club_schedule.items

    filtered_club_schedule_for_schedule_date.each do |item|
      # puts 'loop'
      list_str << "#{item.name} (#{item.instructor_name})\n"
      list_str <<  "#{item.location}\n"
      list_str << "#{item.start_time.strftime('%H:%M')} ~ #{item.end_time.strftime('%H:%M')}\n"
      list_str << "------\n\n"
    end

    list_str
  end

  def filtered_club_schedule_for_schedule_date
    return @club_schedule_for_today if defined?(@club_schedule_for_today)
    @club_schedule_for_today = club_schedule.items.select do |item|
      item.day_of_week == schedule_date.strftime('%A').downcase.to_sym &&
        item.for_kids.to_i == 0 && item.school.to_i == 0
    end

    if !['Saturday', 'Sunday'].include?(schedule_date.strftime('%A'))
      @club_schedule_for_today = @club_schedule_for_today.select do |item|
        item.start_time.strftime('%H%M').to_i > 1800
      end
    end

    return @club_schedule_for_today
  end

  def club_schedule
    @club_schedule ||= client.schedule_for_club(club_id)
  end

  def client
    @client ||= CentralSports::Client.new
  end

  def schedule_date
    Time.now.in_time_zone("Tokyo") + 1.day
  end

  def self.send_daily_schedule
    LineUser.where.not(central_ids: nil).where.not(central_ids: []).each do |user|
      user.central_ids.each do |club_id|
        LineService.new.send_message(user.line_id, type: 'text', text: CentralSportsService.new(club_id).schedule_message)
      end
    end
  end
end
