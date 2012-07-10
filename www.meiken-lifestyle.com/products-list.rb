# 対象URL : http://www.meiken-lifestyle.com/products/list.php
require 'mitsubachi.rb'

client = $e.create_mitsubachi_client
tempfile = Mitsubachi::TemporaryFile.new

# 商品一覧から商品情報を取得する
$e.root_node.find('div.listarea').each do |div|
  a = div.find_one('h3 > a')
  detail_url = $e.get_absolute_url(a.attr['href'])
  product_id = detail_url[/product_id=(\d+)/, 1]
  product_name = a.text
  description = div.find_one('p.listcomment').text
  price = div.find_one('span.price').text
  csvdata = [product_id, product_name, description, price, detail_url].map{|s| s.strip.chomp}
  tempfile.write_csv(csvdata)
end

# 取得した商品情報を保存する
current_time = Time.now.strftime('%Y%m%d%H%M%S')
current_page_no = $e.get_assigned_parameter('current_page_no') # 前のページから渡されたパラメータ
current_page_no = 1 if current_page_no.nil?

request = Mitsubachi::ResourceStoreRequest.new
request.file_name = "result/#{current_time}-products_list-#{current_page_no}.txt"
request.file = tempfile.file
request.content_type = 'text/plain'
client.resource_store(request)

# 次のページへのリンクを探す
a = $e.root_node.find('ul.pagenumberarea > li > a').detect{|a| a.text.include?('次へ')}
return unless a

page_no = a.attr['onclick'][/fnNaviPage\('(\d+)'\)/, 1]

# 次のページへ
request = Mitsubachi::HttpFetchRequest.new
request.url = $e.get_absolute_url(a.attr['href']) # 次のページのURLを指定
request.script_name = $e.script_file_name         # 現在実行中のスクリプトを指定
request.method = Mitsubachi::HttpMethod::POST     # HTTPメソッドにPOSTを指定
request.add_entity_parameter('pageno', page_no)   # POSTパラメータ
request.add_parameter('current_page_no', page_no) # 次のページに渡す任意のパラメータ

client.http_fetch(request)

