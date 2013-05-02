require 'rack/contrib/try_static'
require 'rack/contrib/not_found'
require 'rack/rewrite'

use Rack::Deflater

use Rack::TryStatic,
  urls: %w[/],
  root: "_site",
  try: ['index.html', '/index.html'],
  header_rules: [
    ["/assets", {'Cache-Control' => 'public, max-age=31536000'}]
  ]

run Rack::NotFound.new('_site/404.html')
