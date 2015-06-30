require 'osc-ruby'
require 'socket'

server = TCPServer.new('localhost', 8001)

loop do

  socket = server.accept
  request = socket.gets

  STDOUT.puts request
  idx = request.index(':')
  note = /\/(\:.*\s)HTTP/.match(request)[1]
  STDOUT.puts note

  s = UDPSocket.new
  #m = OSC::Message.new( "/run-code" , "play :c4\nsleep 1\nplay :d4" )
  m = OSC::Message.new( "/run-code" , "play #{note}\n" )
  s.send(m.encode(), 0, 'localhost', 4557)

  response = "Thanks!\n"

  socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"

  socket.print "\r\n"

  socket.print response

  socket.close

end