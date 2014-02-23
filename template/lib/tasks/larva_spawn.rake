namespace :larva_spawn do
  task :start do
    config_dir = File.expand_path('../../../config', __FILE__)
    logfile = "./log/larva_spawn.log"
    options = {
      meducation_sdk_secret_key: ENV['LARVA_SPAWN_API_KEY'],
      env: ENV['ENV'],
      config_dir: config_dir,
      logfile: logfile
    }
    LarvaSpawn::Daemon.start(options)
  end
end

