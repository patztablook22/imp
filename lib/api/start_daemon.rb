module IMP

  def start_daemon
    begin
      Daemon.start nil
      return true
    rescue
      return false
    end
  end

end
