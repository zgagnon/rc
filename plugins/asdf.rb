require_relative "plugin"

class ASDF < Plugin
  
    @@versions = {
        'nodejs' => %w[12.18.3 12.14.1 14.7.0],
        'ruby' => %w[2.7.1 2.6.2 2.6.6],
        'java' => ['adoptopenjdk-11.0.8+10'],
        'golang' => ['1.14.6']
    }
  
    def self.getVersions
      @@versions.clone
    end
  
    def is_installed?
      !((find_executable0 'asdf').nil?)
    end
  
    def install
      installed = checking_for(to_s) do
        is_installed?
      end
      unless installed
        puts 'Installing ASDF'
          system('git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0-rc1')
          system('echo ". $HOME/.asdf/asdf.sh" >> ~/.zshrc')
          puts '-----------------------------------------------------'
          puts 'Please restart your terminal session and run this again'
        return
      end
  
      plugins, _, _ = Open3.capture3('asdf plugin list')
      puts 'Installed plugins:'
  
      plugins_to_install = ASDF.getVersions
      
      plugins.split(" ").each do |installed|
        puts @@versions
        puts installed.strip
        plugins_to_install.delete(installed.strip)
      end
  
      puts 'Plugins to install:'
      puts plugins_to_install.keys
  
      plugins_to_install.keys.each do |plugin|
        system("asdf plugin add #{plugin}")
      end
  
      @@versions.keys.each do |plugin|
        installed, _, _ = Open3.capture3("asdf list #{plugin}")
        needed = Set.new(@@versions[plugin])
        installed.split("\n").each do |version|
          strip = version.strip
          needed = needed.delete(strip)
        end
  
        puts "#{plugin} versions installed"
        puts installed
        puts "#{plugin} versions to install"
        puts needed.to_a
  
        needed.each do |version|
          puts "Installing #{plugin} #{version}"
          system("asdf install #{plugin} #{version}")
        end
      end
    end
  
    def to_s
      "ASDF"
    end
  
    def dependencies
      [Brew]
    end
  end