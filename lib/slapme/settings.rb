require 'yaml'

module Slapme
  module Settings
    def self.[](key)
      @settings ||= load_settings
      @settings[key]
    end

    private

    def self.load_settings
      if File.exists?(settings_path)
        YAML.load_file(settings_path)
      else
        raise 'Configuration file missing. Copy config/examples/settings.yml to config/settings.yml with you configurations'
      end
    end

    def self.settings_path
      @settings_path ||= File.join(Slapme.root, 'config', 'settings.yml')
    end
  end
end
