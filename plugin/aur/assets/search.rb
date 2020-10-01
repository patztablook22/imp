# frozen_string_literal: true
todo = Task?[0]
Task> 'Arch User Repository'

buf   = []

begin

  index = Index.new todo

  unless index.empty?
    index.prepare!
    index.get do |pkg|
      buf << pkg
    end
  end

rescue

  buf = :network

end

Cli.del
App.result buf
