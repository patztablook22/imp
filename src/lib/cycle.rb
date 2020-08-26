module Cycle

  @@path

  # run a cycle
  # called from without
  def self.go! name
    @@path = "#$src/cycle/#{name}" 
    require_relative "#@@path/run"
  end

  # run a phase
  # called from within
  def go! name = nil
    path = "#@@path/phase/#{name}.rb"
    unless name.nil? or !File.file? path
      require_relative path
    end
  end

end
