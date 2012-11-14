require 'eventmachine'

class DarkwingsServer < EventMachine::Protocols::SmtpServer

  def receive_recipient(recipient)
    puts "Received RESTful request: #{recipient}"
    request = routes(recipient)
    puts "Request: #{request.inspect}"
    true
  end

  def receive_data_chunk(lines)
    lines.each do |line|
      puts line
    end
    true
  end

  ROUTES = [
    {pattern: /GET \/documents\/(d+)/, action: :show},
    {pattern: /GET \/documents/, action: :index},
    {pattern: /POST \/documents\/new/, action: :new},
  ]

  def routes(recipient)
    ROUTES.each do |r|
      match = r[:pattern].match recipient
      return r if match
    end
  end
end

# Note that this will block current thread.
EventMachine.run {
  EventMachine.start_server "0.0.0.0", ARGV[0] || 8081, DarkwingsServer
}