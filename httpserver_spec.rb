require 'HttpServer'

describe HttpServer do
  it 'Should return index.html12 for default request' do 
    serv = HttpServer.new(nil, "GET / HTTP/1.1", Dir.getwd)
    file = serv.getFile
    file.should =~ /(.?)index.html/
  end
  it 'Should return the filename for the request' do 
    serv = HttpServer.new(nil, "GET /test.html HTTP/1.1", Dir.getwd)
    file = serv.getFile
    file.should match /(.?)test.html/
  end
  
  it "should write out content to session" do
    session = StringIO.new #In memory object so we can test the interacts
    serv = HttpServer.new(session, "GET /test.html HTTP/1.1", Dir.getwd)
    serv.respond();
    session.string.should include '<p>A B C D</p>'
  end
  
  it "should return HTTP 200 for valid request" do
    session = StringIO.new
    serv = HttpServer.new(session, "GET /test.html HTTP/1.1", Dir.getwd)
    serv.respond();
    session.string.should include 'HTTP/1.1 200/OK'
  end
end