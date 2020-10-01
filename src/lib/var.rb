# frozen_string_literal: true
module Env

  # variable template
  # set/get/...

  class Var
    
    # id of last class bump
    @@bump = 0

    # id of last instance bump
    @bump

    # data
    @data
 
    # assigned instead of :empty value
    # if nil, true is assigned instead
    # can be set only once
    @empty

    # ARGV option abbreviation
    # variable listed in --help 
    # if @opt != nil or --verbose
    @opt

    # short manual / description
    @man
    
    # bump class
    def self.bump!
      @@bump += 1
    end

    # age / obsoleteness
    # number of bumps without edit
    def age
      @@bump - @bump
    end

    # get value
    def get
      @data
    end

    # value value and bump instance
    def value val

      @bump = @@bump

      if val == :empty
        if @empty.nil?
          value true
        elsif @empty == :empty
          value nil
        else
          @data = @empty
        end
      end

    end

    def empty val
      return unless @empty.nil?
      if val == :same
        @empty = @data
      else
        @empty = val
      end
    end

    def man= val
      @man = val
    end

    def man
      @man
    end

    def opt= val
      @opt = val
    end

    def opt
      @opt
    end

  end

  # simple number
  # normally reassigned (see Abacus below)

  class Number < Var
    def get
      if @data.nil?
        0
      else
        @data
      end
    end

    def value val
      case val
      when Integer
        @data = val
      when String
        throw :type unless val.to_i.to_s == val
        @data = val.to_i
      when TrueClass
        @data = 1
      when FalseClass
        @data = 0
      end
      super
    end
  end

  # number that increases/decrease instead of reassigning
  # e.g.
  # Abacus.get =>  42
  # Abacus.set    -20 
  #               ~~~
  # Abacus.get =>  22
  #
  # resets to 0 each bump

  class Abacus < Number
    def value val
      current = get
      super
      @data += current unless current.nil? or age > 0
    end
  end

  # list of items
  # set appends instead of reassigning

  class List < Var
    def value val
      return if val.class == TrueClass
      case val
      when Array
        val.each do |it|
          if it == :empty
            @data = @empty
          else
            @data = @data.to_a << it
          end
        end
      when String
        @data = @data.to_a + val.split(/[, ]/)
        super
      else
        @data = @data.to_a << val
        super
      end
    end
  end

  # boolean variable
  # normally reassigned
  # converts datatypes

  class Boolean < Var
    def value val
      case val
      when TrueClass
        @data = true
      when FalseClass
        @data = false
      when String
        val.downcase!
        @data = true  if val == 'true'
        @data = false if val == 'false'
      when Integer
        @data = val > 0
      end
      super
    end
  end

  # textual variable
  # normally reassigned

  class Text < Var
    def value val

      return if val.nil?

      if val.class != Array
        val = Array[val]
      end

      val.map! do |it|
        if it == :empty
          @empty
        else
          it
        end
      end

      if val.class == Array
        val = val.join ' '
      end

      @data = val
      super

    end
  end

end
