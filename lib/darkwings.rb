require 'eventmachine'

class DarkwingsServer < EventMachine::Protocols::SmtpServer

  def receive_recipient(recipient)
    puts "Received RESTful request: #{recipient}"
    true
  end

  def receive_data_chunk(lines)
    lines.each do |line|
      puts line
    end
    true
  end
end

# Note that this will block current thread.
EventMachine.run {
  EventMachine.start_server "127.0.0.1", ARGV[0] || 8081, DarkwingsServer
}