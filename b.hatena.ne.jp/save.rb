require 'mitsubachi.rb'

temp_file = Mitsubachi::TemporaryFile.new
temp_file.write_bytes($e.http_response_body)

request = Mitsubachi::ResourceStoreRequest.new
request.file = temp_file.file
request.file_name = $e.get_assigned_parameter('file_name')
request.content_type = $e.get_assigned_parameter('content_type')

client = $e.create_mitsubachi_client
client.resource_store(request)
