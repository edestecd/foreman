# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :job_template,   nil
set :runner_command, "script/rails runner"
set :bundle_gemfile, "Gemfile"
set :bundle_command, "bundle exec"
set :output,         nil

job_type :command, ":task :output"
job_type :rake,    "cd :path && :environment_variable=:environment BUNDLE_GEMFILE=:bundle_gemfile :bundle_command rake :task --silent :output"
job_type :script,  "cd :path && :environment_variable=:environment BUNDLE_GEMFILE=:bundle_gemfile :bundle_command script/:task :output"
job_type :runner,  "cd :path && :runner_command -e :environment ':task' :output"

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every :sunday, :at => '12:00 am', :roles => [:app] do
  rake "reports:expire days=31"
end

every :day, :at => '2:00 am', :roles => [:db] do
  script "db_backup --dir /san/dragonfly/:environment/web_apps/foreman/db_backups --max 7 --gzip"
end

every :day, :at => '5:00 am', :roles => [:app] do
  rake "reports:daily days=1"
end

every :monday, :at => '5:15 am', :roles => [:app] do
  rake "reports:weekly days=7"
end

every :month, :at => '5:30 am', :roles => [:app] do
  rake "reports:monthly days=31"
end
