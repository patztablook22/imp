# frozen_string_literal: true
module Options

  @@data

  def self.parse

    data = {}

    ARGV.each do |arg|
      if arg =~ /\A--/
        # --arg

        if arg == '--'
          Err << 'invalid syntax: --'
          next
        end

        assoc = arg[2..-1].split('=')
        key = assoc.shift
        val = assoc&.join('=')
        val = :empty if val.empty?

        if key == 'todo'
          data['todo'] = data['todo'].to_a << val
        else
          data[key] = val
        end

      elsif arg =~ /\A-/
        # -arg

        if arg == '-'
          Err << 'invalid syntax: -'
          next
        end

        arg = arg[1..-1]
        arg.each_char do |opt|
          data['-' + opt] = true
        end

      else
        # arg

        data['todo'] = data['todo'].to_a << arg

      end

    end

    data

  end

end

