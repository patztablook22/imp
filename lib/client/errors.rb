# frozen_string_literal: true

module IMP
  module Errors

    # Exception class used when message from incompatible version is received
    class IncompatibleVersion < StandardError
      def initialize(version)
        super("Received a message from version #{version}. Expected message from version #{IMP::VERSION}")
      end
    end

  end
end
