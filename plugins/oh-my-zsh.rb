require_relative "plugin"

class OhMyZsh < Plugin
    
    def is_installed?
        File.exist?(ENV['HOME'] + "/.oh-my-zsh")
    end

    def install
        system('sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')
        system('git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k')
    end    
  
    def to_s
        "Oh My Zsh"
    end
end