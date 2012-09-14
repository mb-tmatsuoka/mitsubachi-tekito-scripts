require 'mitsubachi.rb'

client = $e.create_mitsubachi_client

# スクレイピング対象ページを保存
tempfile = $e.http_response_body_to_temp_file
file_name = Time.now.strftime('pages/%Y%m%d%H%M%S.html')
content_type = 'text/html'
client.simple_resource_store(tempfile.file, file_name, content_type)



# スクレピング処理



# スクレイピング対象ページを削除
delete_request = Mitsubachi::ResourceDeleteRequest.new
delete_request.file_name = file_name
client.resource_delete(delete_request)
