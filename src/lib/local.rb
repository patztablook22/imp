# frozen_string_literal: true
require_relative 'plugin'

module Local

  extend self

  @@all = Array.new

  def init
    @@all.clear
    Plugin.local.each do |ara|
      ara.each do |pkg|
        @@all << pkg
      end
    end
  end

  def list
    @@all
  end

  def [] pkg
    @@all.find do |local|
      pkg =~ local
    end
  end

  private

  def impportAll
    Dir[ Env['local'] + '/*'  ].each do |dir|
    end
  end

  def impportOne dir
  end

end
