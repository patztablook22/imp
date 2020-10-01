# frozen_string_literal: true
def pm
  Cache['distro']
end

raise 'distro package manager not found' if pm.nil?
