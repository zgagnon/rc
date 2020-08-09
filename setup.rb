#!/usr/bin/ruby
require 'mkmf'
require 'open3'
require 'set'

puts 'Checking for applications'

class Brew
  include Comparable

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

  def <=>(other)
    if other.dependencies.include? self.class
      return -1
    end

    0
  end

  def dependencies
    []
  end
end

class ASDF
  include Comparable

  @versions = {
      'nodejs' => %w[12.18.3 12.14.1 14.7.0],
      'ruby' => %w[2.7.1 2.6.2 2.6.6],
      'java' => ['adoptopenjdk-11.0.8+10'],
      'golang' => ['1.14.6']
  }

  def is_installed?
    !((find_executable0 'asdf').nil?)
  end

  def install
    installed = checking_for(to_s) do
      is_installed?
    end
    unless installed
      puts 'Installing ASDF'
      #   system('git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0-rc1')
      #   system('echo ". $HOME/.asdf/asdf.sh" >> ~/.zshrc')
      #   puts '-----------------------------------------------------'
      #   puts 'Please restart your terminal session and run this again'
      return
    end

    plugins, _, _ = Open3.capture3('asdf plugin list')
    puts 'Installed plugins:'

    plugins_to_install = @versions.clone
    plugins.split(" ").each do |installed|
      puts installed.strip
      plugins_to_install.delete(installed.strip)
    end

    puts 'Plugins to install:'
    puts plugins_to_install.keys

    plugins_to_install.keys.each do |plugin|
      system("asdf plugin add #{plugin}")
    end

    @versions.keys.each do |plugin|
      installed, _, _ = Open3.capture3("asdf list #{plugin}")
      needed = Set.new(@versions[plugin])
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

  def <=>(other)
    if other.dependencies.include? self.class
      return -1
    elsif dependencies.include? other.class
      return 1
    end
    0
  end

  def dependencies
    [Brew]
  end
end

class Vundle
  include Comparable

  def is_installed?
    File.exist?(ENV['HOME'] + "/.vim/bundle/Vundle.vim")
  end

  def install


  end

  def to_s
    "Vundle"
  end

  def <=>(other)
    if other.dependencies.include? self.class
      return -1
    end
    0
  end

  def dependencies
    []
  end
end

applications = [Vundle.new, ASDF.new, Brew.new].sort

app_needs_install = {}

def checking_for(m, fmt = nil)
  (f = caller[0][/in `([^<].*)'$/, 1]) and f << ": " #` for vim #'
  m = "checking #{/\Acheck/ =~ f ? '' : 'for '}#{m}... "
  message "%s", m
  a = r = nil
  Logging::postpone do
    r = yield
    a = (
    if fmt
      "#{fmt % r}"
    else
      r ? 'yes' : "no"
    end)
    "#{f}#{m}-------------------- #{a}\n\n"
  end
  message "%s\n", a
  Logging::message "--------------------\n\n"
  r
end

applications.each do |app|
  app.install
end
#
#
# if app_needs_install['brew']
#   puts 'Homebrew not found'
#   system('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"')
# end
#
# if app_needs_install['asdf']
#   puts 'ASDF not found'
#   system('git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0-rc1')
#   system('echo ". $HOME/.asdf/asdf.sh" >> ~/.zshrc')
#   puts '-----------------------------------------------------'
#   puts 'Please restart your terminal session and run this again'
# else
#   plugins, _, _ = Open3.capture3('asdf plugin list')
#   puts 'Installed plugins:'
#
#   plugins_to_install = versions.clone
#   plugins.split(" ").each do |installed|
#     puts installed.strip
#     plugins_to_install.delete(installed.strip)
#   end
#
#   puts 'Plugins to install:'
#   puts plugins_to_install.keys
#
#   plugins_to_install.keys.each do |plugin|
#     system("asdf plugin add #{plugin}")
#   end
#
#   versions.keys.each do |plugin|
#     installed, _, _ = Open3.capture3("asdf list #{plugin}")
#     needed = Set.new(versions[plugin])
#     installed.split("\n").each do |version|
#       strip = version.strip
#       needed = needed.delete(strip)
#     end
#
#     puts "#{plugin} versions installed"
#     puts installed
#     puts "#{plugin} versions to install"
#     puts needed.to_a
#
#     needed.each do |version|
#       puts "Installing #{plugin} #{version}"
#       system("asdf install #{plugin} #{version}")
#     end
#   end
# end
#
# unless File.exist?(ENV['HOME'] + "/.vim/bundle/Vundle.vim")
#   puts 'Installing Vundle'
#   system('git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim')
# end
