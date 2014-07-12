namespace :larva_spawn do
  task :start do
    config_dir = File.expand_path('../../../config', __FILE__)
    logfile = "./log/larva_spawn.log"
    options = {
      env: ENV['ENV'],
      config_dir: config_dir,
      logfile: logfile
    }
    LarvaSpawn::Daemon.start(options)
  end
end

