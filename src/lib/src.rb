module Src

  def src
    Git + "/src"
  end

  def lib
    src + "/lib"
  end

  def cycle
    src + "/cycle"
  end

end
