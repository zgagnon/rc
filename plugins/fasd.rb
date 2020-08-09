require_relative 'plugin'

class FASD < Plugin

    def is_installed?
        !((find_executable0 'fasd').nil?)
    end

    def to_s
        "FASD"
    end

    def install
        system("brew install fasd")
    end

    def depends
        ["brew"]
    end
end