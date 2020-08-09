class Plugin
    include Comparable
  
    def is_installed?
      raise "Not Implemented"
    end
  
    def install
        raise "Not Implemented"  
    end
  
    def to_s
        raise "Not Implemented"

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
      []
    end
  end