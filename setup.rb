#!/usr/bin/ruby
require 'mkmf'
require 'open3'
require 'set'
require_relative './plugins/asdf'
require_relative './plugins/brew'
require_relative './plugins/vundle'
require_relative './plugins/oh-my-zsh'
require_relative './plugins/fasd'

puts 'Checking for applications'

applications = [Vundle.new, ASDF.new, Brew.new, OhMyZsh.new, FASD.new].sort

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
  installed = checking_for(app.to_s) do
    app.is_installed?
  end

  unless installed
    app.install
  end
end
