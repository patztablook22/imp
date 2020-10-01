# frozen_string_literal: true
require_relative 'local'

class Pkg

  @name
  @version
  @files
  @desc
  @deps
  @plugin
  @sync
  
  attr_accessor :name, :version, :files, :desc, :deps, :plugin, :sync

  def =~ pkg
    self.name == pkg.name and self.plugin == pkg.plugin
  end

  def == pkg
    self =~ pkg and self.version == pkg.version
  end

  def sync!
    local = Local[self]
    if local.nil?
      @sync = nil
    elsif local == self
      @sync = true
    else
      @sync = false
    end
    @sync
  end

end
