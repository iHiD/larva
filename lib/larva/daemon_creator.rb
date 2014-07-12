require 'fileutils'
require 'active_support/core_ext'

module Larva
  class DaemonCreator
    def self.create(*args)
      new(*args).create
    end

    attr_reader :template_dir, :daemon_name, :daemon_dir
    def initialize(pwd, daemon_name)
      @template_dir = File.expand_path('../../../template', __FILE__)
      @daemon_name = daemon_name
      @daemon_dir = "#{pwd}/#{daemon_name}"
    end

    def create
      error_exit("Please provide a daemon name. e.g. larva spawn my_daemon_name") if daemon_name.blank?
      error_exit("Directory #{daemon_dir} already exists. Please remove it before continuing.") if File.exists?(daemon_dir)

      # Copy template directory
      FileUtils.cp_r(template_dir, daemon_dir)
      rename_directories
      rename_files
      rename_file_contents
      alter_files if respond_to?(:alter_files)
      git_it_up
      $stdout.puts "Daemon '#{daemon_name}' created succesfully :)"
    end

    private

    def rename_directories
      Dir.glob("#{daemon_dir}/**/*/").each do |original_path|
        new_path = original_path.gsub('larva_spawn', daemon_name)
        next if new_path == original_path

        FileUtils.mv(original_path, new_path)
        rename_directories
        return
      end
    end

    def rename_files
      Dir.glob("#{daemon_dir}/**/*").each do |original_path|
        new_path = original_path.gsub('larva_spawn', daemon_name)
        FileUtils.mv(original_path, new_path) if new_path != original_path
      end
    end

    def rename_file_contents
      Dir.glob("#{daemon_dir}/**/*").each do |path|
        next unless File.file?(path)
        contents = File.read(path)
        File.open(path, 'w+') do |file|
          contents.gsub!("LarvaSpawn", daemon_name.camelize)
          contents.gsub!("larva_spawn", daemon_name)
          contents.gsub!("LARVA_SPAWN", daemon_name.upcase)
          file.write(contents)
        end
      end
    end

    def git_it_up
      `cd #{daemon_name} && git init && git add . && git commit -am "Create basic daemon" && cd ..`
    end
  end
end
