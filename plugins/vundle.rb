require_relative "plugin"

class Vundle < Plugin
    include Comparable
  
    def is_installed?
      File.exist?(ENV['HOME'] + "/.vim/bundle/Vundle.vim")
    end
  
    def install
  
  
    end
  
    def to_s
      "Vundle"
    end
  
    
  
    def dependencies
      []
    end
  end