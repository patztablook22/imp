# frozen_string_literal: true

module IMP
  def start_daemon
    Daemon.start config: nil
    true
  rescue StandardError
    false
  end
end
