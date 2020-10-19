module IMP
  class Client

    def listener

      loop do

        buff = @sock&.gets
        raise IOError if buff.nil?

        buff = JSON.parse(buff)
        uuid = buff['uuid']
        data = buff['data']
        responded(uuid, data)

      rescue IOError

        @requests.each_key do |uuid|
          responded(uuid, nil)
        end

        @requests = nil

        close
        break

      rescue
      end

    end

  end
end
