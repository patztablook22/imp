file = Task["args"][0][0]
hash = Task["args"][0][1]
func = case Task["checksum"]
       when "sha128sum"; Digest::SHA128
       when "sha256sum"; Digest::SHA256
       when "sha512sum"; Digest::SHA512
       when    "md5sum"; Digest::MD5
       else; Task^1
       end

Task> file

buff = File.read file rescue Task^-1
buff = func.hexdigest buff

=begin
  puts
  puts "PATH " + file
  puts "FILE " + buff
  puts "HASH " + hash
  puts
=end

Task^-1 unless buff == hash
Task^ 0