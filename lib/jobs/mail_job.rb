class MailJob
  include SuckerPunch::Job

  def perform(url, options)
    begin
      RestClient.post(url, options)
    rescue SocketError
      puts "Can't connect: #{url}. Options: #{options.inspect}.\n\n#{$!}"
    rescue
      puts "Exception : #{url}. Options: #{options.inspect}.\n\n#{$!}"
    end
  end
end
