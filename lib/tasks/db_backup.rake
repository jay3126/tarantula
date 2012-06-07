namespace :db do
  def retrieve_db_info
    result = File.read "#{RAILS_ROOT}/config/database.yml"
    result.strip!
    config_file = YAML::load(ERB.new(result).result)
    return [
      config_file[RAILS_ENV]['database'],
      config_file[RAILS_ENV]['username'],
      config_file[RAILS_ENV]['password']
    ]
  end
  
  desc "Backup the database. Use FILEPATH=... to change the path from default [/opt/testia/backup/tarantula/daily.sql]"
  task :backup => :environment do
    archive = ENV['FILEPATH'] || "/opt/tarantula/daily.sql"
    database, user, password = retrieve_db_info
    
    cmd = "/usr/bin/env mysqldump -u#{user} "
    puts cmd + "... [password filtered]"
    cmd += " -p'#{password}' " unless password.nil?
    cmd += " #{database} > #{archive}"
    sh cmd
  end
  
end