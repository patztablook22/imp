class Depend

  @package
  @@tries = [
    "/usr/bin",
    "/usr/lib",
    "/usr/lib32",
    "/usr/lib64",
  ]

  def self.init

    Console.log("dependency")

    tmp = []

    @@tries.each do |try|
      return if File.symlink? try and @@tries.include? File.readlink(try)
      tmp << try
    end

    @@tries = tmp

  end
  
  def initialize pkg
    @package = pkg
  end

  def present?

    Console.log("dependency", @package)

    command = String.new
    command << "find "
    @@tries.each do |try|
      command << try << " "
    end
    command << "-iname "

    dissolve do |it|

      cmd  = command + '"*' + it + '*" '
      pipe = Pipe.new
      pipe.command = cmd
      pipe.go!

      return true unless pipe.out.empty?

    end

    false

  end

  private

  def dissolve

    yield @package

    parts = @package.split("-")
    return if parts.size < 1

    parts.each { |part| yield part }

  end

end
