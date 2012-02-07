require 'mitsubachi.rb'
client = $e.create_mitsubachi_client

tempfile = Mitsubachi::TemporaryFile.new
$e.root_node.find('div.entry-body').each do |entry|
  title_node = entry.find_one('blockquote > cite')
  next unless title_node
  title = title_node.attr['title']
  url = entry.find_one('h3 > a').attr['href']
  category = entry.find_one('.entry-info > .category').text
  tags = entry.find('.entry-info > .tags > a.tag').map{|n| n.text}
  users = entry.find_one('.entry-info > .users').text
  timestamp = entry.find_one('.entry-info > .timestamp').text
  quoted_body = entry.find_one('blockquote').text.gsub(/[\r\n]/mu, '').strip

  tsv = [title, url, category, tags.join(','), users, timestamp, quoted_body].join("\t")
  tempfile.write_stringln(tsv)
end

request = Mitsubachi::ResourceStoreRequest.new

request.file_name = 'result/'+Time.now.strftime('%Y%m%d%H%M%S')+'-b.hatena.ne.jp.txt'
request.file = tempfile.file
request.content_type = 'text/plain'
client.resource_store(request)

