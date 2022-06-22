require 'sinatra'

$LOG_DIR = ENV.fetch('LOG_DIR') do
  File.expand_path('./tmp/logs', __dir__)
end

class String
  def sanitize
    self.gsub(/[^[:print:]]/, '')
  end
end

get '/healthcheck' do
  'OK'
end

post '/' do
  client_id = params.fetch(:client).downcase.sanitize
  message = params.fetch(:message).sanitize
  timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S.%L %z')

  if client_id.length == 0 || client_id.length > 36 || client_id.match(/[^a-z0-9\-]/)
    halt 400, 'Invalid client id'
  elsif message.length > 1024
    halt 400, 'Message cannot be longer than 1024 characters'
  else
    File.open(File.join($LOG_DIR, client_id + '.log'), 'a') do |f|
      f.puts "[#{request.ip}] [#{timestamp}] #{message}"
    end
  end
end
