class HttpServer
  def initialize(session, request, path)
    @session = session
    @request = request
    @path = path
  end
  
  def getFile()
    log @request
    if @request =~ /GET .* HTTP.*/
      filename = @request.gsub(/GET /, '').gsub(/ HTTP.*/, '')
    end
    filename = @path + filename
    log @request
    if !File.file?(filename)      
      filename = @path + '/index.html'
    end
    
    return filename
  end
  
  def respond()
    file = getFile()
    log "Processing #{file}"
    begin
      if File.exist?(file)
        @session.print "HTTP/1.1 200/OK\r\nServer: Benserv\r\nContent-type: text/html\r\n\r\n"
        src = File.open(file)
        while (not src.eof?)
          buffer = src.read(256)
          @session.write(buffer)
        end
        src.close
      else
        @session.print "HTTP/1.1 404/Object Not Found\r\nServer: Benserv\r\n\r\n"
      end
    ensure
      @session.close
    end
  end
end