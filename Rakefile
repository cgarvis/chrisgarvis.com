require "rubygems"
require 'rake'
require 'yaml'

namespace :assets do
  desc "Precompile assets"
  task :precompile do
    Rake::Task["clean"].invoke
    sh "bundle exec jekyll build"
  end
end

desc "Remove compiled files"
task :clean do
  sh "rm -rf #{File.dirname(__FILE__)}/_site/*"
end

desc 'create new posts: rake new title="New Title" future=5'
# rake new future=0 title="New post title goes here" slug="slug-override-title"
task :new do
  require 'rubygems'
  require 'chronic'

  title = ENV["title"] || "New Title"
  future = ENV["future"] || 0
  slug = ENV["slug"] ? ENV["slug"].gsub(' ','-').downcase : title.downcase.strip.gsub(/[^\w-]/, ' ').gsub(/\s+/, '-')

  if future.to_i < 3
    TARGET_DIR = "_posts"
  else
    TARGET_DIR = "_drafts"
  end

  if future.to_i.zero?
    filename = "#{Time.new.strftime('%Y-%m-%d')}-#{slug}.markdown"
  else
    stamp = Chronic.parse("in #{future} days").strftime('%Y-%m-%d')
    filename = "#{stamp}-#{slug}.markdown"
  end
  path = File.join(TARGET_DIR, filename)
  post = <<-HTML
---
layout: post
title: "TITLE"
date: DATE
---

HTML
  post.gsub!('TITLE', title).gsub!('DATE', Time.new.to_s)
  File.open(path, 'w') do |file|
    file.puts post
  end
  puts "new post generated in #{path}"
end

desc "Launch preview environment"
task :preview do
  system "bundle exec jekyll serve --watch --future --drafts"
end # task :preview
