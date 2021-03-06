#!/usr/bin/env ruby
require 'thor'
require 'dare'

class DareCLI < Thor
  include Thor::Actions
  desc "new", "creates a new app"
  def new(app_name)
    add_file("#{app_name}/Gemfile") do
      "gem 'dare', '#{Dare::VERSION}'"
    end
    add_file "#{app_name}/Rakefile" do
"desc \"Build #{app_name}.js\"
task :build do
  require 'opal'
  require 'opal-jquery'
  env = Opal::Environment.new
  env.append_path \".\"
  env.append_path `bundle show dare`.chomp

  File.open(\"#{app_name}.js\", \"w+\") do |out|
    out << env[\"#{app_name}\"].to_s
  end
end"
    end
    add_file "#{app_name}/#{app_name}.rb" do
"require 'dare'
require 'opal-jquery'

class #{app_name[0].upcase + app_name[1..-1]} < Dare::Window

  def initialize
    super width: 640, height: 480, border: true
  end

  def draw
    #code that runs every frame
  end

  def update
    #code that runs every frame
  end

end

#{app_name[0].upcase + app_name[1..-1]}.new.run!"
    end
    add_file "#{app_name}/#{app_name}.html" do
"<!DOCTYPE html>
<html>
  <head>
    <script src=\"http://code.jquery.com/jquery-1.11.0.min.js\"></script>
    <script src=\"http://cdn.opalrb.org/opal/0.6.3/opal.min.js\"></script>
  </head>
  <body>
    <script src=\"#{app_name}.js\"></script>
  </body>
</html>"
    end
  end
end

DareCLI.start