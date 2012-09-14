require 'mushikago'

client = Mushikago::Mitsubachi::Client.new(:api_key => 'AKIAIU2K2GVLUEQ7R4UQ', :secret_key => '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')

files = []
offset = 0
has_more_files = 1
while has_more_files == 1
  ret = client.resource_list('hatebu', :offset => offset)
  ret['files'].each do |file|
    files << file['name']
  end
  has_more_files = ret['has_more_files']
  offset += 10
end

files.each do |file|
  puts file
  client.resource_delete('hatebu', file)
end

