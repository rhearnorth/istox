# frozen_string_literal: true

require 'net/http'

url = URI.parse('http://localhost:10300/reset/')
req = Net::HTTP::Get.new(url.to_s)
res = Net::HTTP.start(url.host, url.port) do |http|
  http.request(req)
end

start = Time.now

threads = []
(1..100).each do |i|
  threads << Thread.new do
    (1..50).each do |q|
      random_port = rand(5)
      puts "Making call to port 1030#{random_port} thread: " + i.to_s + ', item:' + q.to_s
      uri = URI("http://localhost:1030#{random_port}/transfer/")
      res = Net::HTTP.post_form(uri, 'transfer_from' => '1', 'transfer_to' => '2', 'amount' => '1.234567890123456')
      puts res.body

      puts 'Finished call thread: ' + i.to_s + ', item:' + q.to_s
    end
  end
end

threads.each(&:join)

finish = Time.now

url = URI.parse('http://localhost:10300/get_amounts/')
req = Net::HTTP::Get.new(url.to_s)
res = Net::HTTP.start(url.host, url.port) do |http|
  http.request(req)
end

puts res.body

diff = finish - start
puts 'Time taken: ' + diff.to_s + ' seconds'
