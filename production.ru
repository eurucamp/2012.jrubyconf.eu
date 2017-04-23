#\ -s puma
# encoding: UTF-8

require 'bundler'
Bundler.setup :production

require 'rack/rewrite'
require 'rack/contrib/try_static'
require 'rack/contrib/not_found'

use Rack::Rewrite do
  r301 %r{/blog/?(.*)}, 'http://blog.eurucamp.org/$1'
  r301 '/feed.xml',     'http://blog.eurucamp.org/feed.xml'
end
use Rack::TryStatic, :root => "build", :urls => %w[/], :try => ['.html', 'index.html', '/index.html']
run Rack::NotFound.new('./build/404.html')
