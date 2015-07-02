#!/usr/bin/env ruby
# encoding: utf-8

require "cuba"
require "redic"
require "json"

def redis
  Redic.new
end

AUTOCOMPLE_KEY = "autocomplete"

# We serve CSS files
Cuba.use Rack::Static, :urls => "/", :index => "index.html", :root => "public"

Cuba.define do
  on "search" do
    on param("term") do |term|
      res.headers["Content-Type"] = "application/json; charset=utf-8"

      if term.empty?
        res.write [].to_json
      else
        min = "[#{term}"
        max = "(#{term}\xff"
        results = redis.call("ZRANGEBYLEX", AUTOCOMPLE_KEY, min, max)

        res.write results.to_json
      end
    end
  end
end
