class YKMan < Plugin
  def is_installed?
    !((find_executable0 'ykman').nil?)
  end

  def install
    system("brew install ykman")
  end

  def to_s
    "Yubico Key Manager"
  end

  def dependencies
    ["brew"]
  end
end