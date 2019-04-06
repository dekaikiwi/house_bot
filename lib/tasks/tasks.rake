namespace :tasks do
  desc "TODO"
  task send_daily_alerts: :environment do
    TaskService.new.send_daily_update
    CentralSportsService.send_daily_schedule
  end

end
