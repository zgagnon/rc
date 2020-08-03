#!/usr/bin/ruby

puts
puts 'Installing home brew package manager'

system(/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)")
require 'mkmf'
require 'open3'
require 'set'

puts 'Checking for applications'

applications = ['brew', 'asdf']
versions = {
	'nodejs' => ['12.18.3'],
	'ruby' => ['2.7.1'],
	'java' => ['adoptopenjdk-11.0.8+10'],
        'go' => ['']
}
status = {}

applications.each do |app|
   status[app] = find_executable app
   if status[app].nil?
	puts "#{app} not found"
   else puts "#{app} found"
	end
end



if status['brew'].nil?
	puts 'Homebrew not found'
	system('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"')
end

if status['asdf'].nil?
	puts 'ASDF not found'
        system('git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0-rc1')
        system('echo ". $HOME/.asdf/asdf.sh" >> ~/.zshrc')
	puts '-----------------------------------------------------'
	puts 'Please restart your terminal session and run this again'
else
	plugins, _, _ = Open3.capture3('asdf plugin list')
	puts 'Installed plugins:'

        plugins_to_install = versions.clone
	plugins.split(" ").each do | installed |
          puts installed.strip
          plugins_to_install.delete(installed.strip)
	end

	puts 'Plugins to install:'
        puts plugins_to_install.keys

        plugins_to_install.keys.each do |plugin|
          system("asdf plugin add #{plugin}") 
        end

        versions.keys.each do |plugin|
          installed, _, _ = Open3.capture3("asdf #{plugin} list")
          needed = Set.new(versions[plugin])
          installed.split("\n").each do |version|
            needed = needed.delete(plugin)
          end

          needed.each do |version|
            puts "Installing #{plugin} #{version}"
            system("asdf install #{plugin} #{version}")
          end
        end
end

unless File.exist?(ENV['HOME']+"/.vim/bundle/Vundle.vim")
        puts 'Installing Vundle'
	system('git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim')
end
