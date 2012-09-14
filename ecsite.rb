# -*- coding : utf-8 -*-
require 'mitsubachi.rb'

domain = 'ecsite'
hanamgri = $e.create_hanamgri_client

$e.root_node.find('a').each do |a|
  url = $e.get_absolute_url(a.attr['href'])
  hanamgri.request_analysis(domain, url)
end
