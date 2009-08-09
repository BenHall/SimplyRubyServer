require 'socket'
require 'HttpServer'


def log(message)
  puts message
end

log 'Starting server on 0.0.0.0:2020'
server = TCPServer.new('0.0.0.0', 2020)
path = Dir.getwd

loop do 
  session = server.accept
  request = session.gets
  log "#{session.peeraddr[2]} (#{session.peeraddr[3]})"
  if(ARGV.length == 1)
    path = ARGV[0]
  end
  Thread.start(session, request) do |session, request|
      HttpServer.new(session, request, path).respond()
  end
end

log 'Stopping server. Amazing requests served...'
