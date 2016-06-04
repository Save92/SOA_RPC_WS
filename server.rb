require 'awesome_print'
require 'json'
require 'net/http'
require 'uri'
require 'xmlrpc/server'

server = XMLRPC::Server.new(1234)

# http://www.latlong.net/
#Example :
# 34.052234
# -118.243685

server.add_handler('my_rpc.lat_lon_info') do |lat, lon|
 results = JSON.parse %x(geocode -j #{lat}, #{lon})

 {
   city: results['results'][0]['address_components'][3]['long_name'],
   country: results['results'][0]['address_components'][6]['long_name']
 }.to_json
end

# http://api.openweathermap.org/pollution/v1/co/34.0,-118/current.json?appid=a3573dcb30e93ad67687f4fb70aa87c6
server.add_handler('my_rpc.co2') do |lat, lon|
 response = Net::HTTP.get(URI.parse("http://api.openweathermap.org/pollution/v1/co/#{lat},#{lon}/current.json?appid=a3573dcb30e93ad67687f4fb70aa87c6"))
  #ap response

 co2 = JSON.parse(response)['data'][0]['value']

 co2
end

# http://api.openweathermap.org/v3/uvi/34,-118/current.json?appid=a3573dcb30e93ad67687f4fb70aa87c6
server.add_handler('my_rpc.uv') do |lat, lon|
 response = Net::HTTP.get(URI.parse("http://api.openweathermap.org/v3/uvi/#{lat},#{lon}/current.json?appid=a3573dcb30e93ad67687f4fb70aa87c6"))
  #ap response

 uv = JSON.parse(response)['data']

 uv
end

server.serve
