require 'bundler/setup'
require 'heroku_san'
require 'fileutils'
require 'net/https'

module HerokuSan::Deploy
  class Eurucamp < Sinatra
    def deploy
      super
      #@stage.rake('utils:update_sitemap')
      #@stage.rake('utils:update_attendees')
    end
  end
end

config_file = File.join(File.expand_path(File.dirname(__FILE__)), 'config', 'heroku.yml')
HerokuSan.project = HerokuSan::Project.new(config_file, :deploy => HerokuSan::Deploy::Eurucamp)

load 'heroku_san/tasks.rb'

require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'sitemap_generator'

namespace :utils do

  desc "Update sponsors"
  task :update_sponsors do
    FileUtils.rm("data/sponsors.yml")

    # http://ruby-doc.org/stdlib-1.9.3/libdoc/net/http/rdoc/Net/HTTP.html
    uri = URI("https://raw.github.com/eurucamp/2012.eurucamp.org/master/data/sponsors.yml")

    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      request = Net::HTTP::Get.new uri.request_uri

      http.request request do |response|
        open "data/sponsors.yml", "w" do |io|
          response.read_body do |chunk|
            io.write chunk
          end
        end
      end
    end
  end

  desc "Update attendees list with data from Lanyrd.com"
  task :update_attendees do
    data = lanyrd_attendees.to_yaml
    File.open('data/attendees.yml', 'w') {|f| f.write(data) }
  end

  desc "Update sitemap"
  task :update_sitemap do
    SitemapGenerator::Sitemap.default_host = 'http://jrubyconf.eu'
    SitemapGenerator::Sitemap.public_path = "source"
    SitemapGenerator::Sitemap.create do
      add '/',           :changefreq => 'hourly'
      add '/policies',   :changefreq => 'weekly'
      add '/imprint',    :changefreq => 'weekly'
      add '/schedule',   :changefreq => 'daily', :priority => 0.8
      add '/venue',      :changefreq => 'daily'
      add '/sponsors',   :changefreq => 'daily'

      add '/blog',       :changefreq => 'hourly', :priority => 0.9
      Dir["source/blog/*"].each do |blog_entry_file|
        post_link = blog_entry_file.gsub(/^source\/blog\/|\.html.markdown$/,"")
        post_link = post_link[0..10].gsub("-","/") + post_link[11,post_link.size]
        add post_link,   :changefreq => 'hourly', :priority => 0.9
      end
    end
    SitemapGenerator::Sitemap.ping_search_engines
  end

  # scrapes eurucamp page on lanyrd.com and returns
  # array of Twitter names
  def lanyrd_attendees
    profile_selector     = '.primary .mini-profile .name a'.freeze
    pagination_selector  = '.pagination li a'.freeze
    base_url             = 'http://lanyrd.com'.freeze
    first_page_path      = '/2012/jrubyconfeu/attendees/'.freeze

    first_page           = Nokogiri::HTML(open(base_url + first_page_path))
    other_pages_paths    = first_page.css(pagination_selector).map { |a| a[:href] }

    (other_pages_paths << first_page_path).map do |relative_path|
      page = Nokogiri::HTML(open(base_url + relative_path))
      page.css(profile_selector).map {|a| a['href'].gsub(/^\/profile\/|\/$/,'') }
    end.flatten.sort
  end
end
