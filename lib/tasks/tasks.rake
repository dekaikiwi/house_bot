namespace :tasks do
  desc "TODO"
  task send_daily_alerts: :environment do
    TaskService.new.send_daily_update
  end

end
