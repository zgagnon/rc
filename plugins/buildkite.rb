class Buildkite < Plugin
  def is_installed?
    !((find_executable0 'bk').nil?)
  end

  def install
    system("brew tap buildkite/cli")
    system("brew install bk")
  end

  def to_s
    "Buildkite"
  end

  def dependencies
    ["brew"]
  end
end