require_relative "plugin"

class Brew < Plugin
  
    def is_installed?
      !((find_executable0 'brew').nil?)
    end
  
    def install
      installed = checking_for(to_s) do
        is_installed?
      end
      unless installed
        puts "Installing Homebrew"
        Open3.capture3('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"')
      end
    end
  
    def to_s
      "Homebrew"
    end
end