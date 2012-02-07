loader.load('mitsubachi.js');

var tempfile = new Mitsubachi.TemporaryFile();
var entries = e.getRootNode().find('div.entry-body');
for(var i=0; i<entries.length; i++) {
  var entry = entries[i];

  var title_node = entry.findOne('blockquote > cite');
  if (title_node == null) {
    continue;
  }
  var title = title_node.attr()['title'];
  var url = entry.findOne('h3 > a').attr()['href'];
  var category = entry.findOne('.entry-info > .category').text();
  var tag_nodes = entry.find('.entry-info > .tags > a.tag');
  var tags = [];
  for(var j=0; j<tag_nodes.length; j++) {
    tags.push(tag_nodes[j].text());
  }
  var users = entry.findOne('.entry-info > .users').text();
  var timestamp = entry.findOne('.entry-info > .timestamp').text();
  var quoted_body = entry.findOne('blockquote').text();

  var tsv = [title, url, category, tags.join(','), users, timestamp, quoted_body].join("\t");
  tempfile.writeStringln(tsv);
  println(tsv);
}

var client = e.createMitsubachiClient();
var request = new Mitsubachi.ResourceStoreRequest();
var now = new Date();
var filename = 'resultjs/' + now.getFullYear() + '-' + now.getMonth() + '-' + now.getDay() + '-b.hatena.ne.jp.txt';
request.setFileName(filename);
request.setFile(tempfile.getFile());
request.setContentType('text/plain');
client.resourceStore(request);

