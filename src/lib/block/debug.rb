# frozen_string_literal: true
require_relative '../cli'

class Debug < Block

  @@active = false    # debug mode active
  @@used   = false    # has it been used?
  @@data   = Array.new

  # print debug message (if set on)
  #
  # Debug> @file
  # Debug> processed(@file)
  #
  def self.> str

    #return unless @@active
    unless @@used
      @@used = true
      STDERR.puts
      STDERR.puts
      STDERR.puts 'IMP DEBUG'
      Cli.hr
      STDERR.puts
    end

    pp str

  end

  # set debug mode
  def self.on!
    @@active = true
  end

  def focus
    App.navi
  end

  def update data
    @@data << data
    if Env['tui']
      @@data << data
      super
      App.render
    elsif @@active
      STDERR.puts data
    end
  end

  def display
    return if @h.nil? or @h < 0
    reset
    @@data.last(@h).each do |it|
      out it
    end
  end

end
