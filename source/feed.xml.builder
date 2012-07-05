xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title    'JRubyConf EU Blog'
  xml.subtitle 'european ruby camp | summer edition'
  xml.id   'http://jrubyconf.eu/'
  xml.link href: 'http://jrubyconf.eu/'
  xml.link href: 'http://jrubyconf.eu/feed.xml', rel: 'self'
  xml.updated blog.articles.first.date.to_time.iso8601
  xml.author { xml.name 'JRubyConf EU Team' }

  blog.articles[0..5].each do |article|
    xml.entry do
      full_url = "http://2012.eurucamp.org" + article.url_without_extension

      xml.title article.title
      xml.link "rel" => "alternate", "href" => full_url
      xml.id full_url
      xml.published article.date.to_time.iso8601
      xml.updated article.date.to_time.iso8601
      xml.author { xml.name article.data.author.presence || 'JRubyConf EU Team' }
      xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html"
    end
  end
end