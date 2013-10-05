require 'jekyll'
require 'jekyll/post'
require 'rubygems'
require 'disqussion'
require 'json'

module Jekyll

  class DisqussionCommentsTag < Liquid::Tag

    def initialize(name, params, tokens)
      
      super
    end

    def render(context)

      site = context.registers[:site]
      settings = site.config['disqus']

      # Local cache setup so we don't hit the sever X amount of times for same data.
      cache_directory = settings['cache_directory'] || "_disqus"
      cache_filename = settings['cache_filename'] || "disqus_cache.json"
      cache_file_path = cache_directory + "/" + cache_filename
      disqus_data = nil

      #configuration options needed
      limit = settings['limit'] || 5
      ul_class = settings['ul_class'] || ""
      image_class = settings['image_class'] || ""

      # If the directory doesn't exist lets make it
      if not Dir.exist?(cache_directory)
        Dir.mkdir(cache_directory) 
      end

      # Now lets check for the cache file.
      if File.exist?(cache_file_path)
        disqus_data = JSON.parse(File.read(cache_file_path));
      else

        # Get the API auth goodies
        api_key = settings['api_key'] || nil
        api_secret = settings['api_secret']

        forum_name = settings['forum_name']

        # Lets connect to disquss
        Disqussion.configure do |config|
          config.api_key = api_key
          config.api_secret = api_secret
        end

        disqus_data = Disqussion::Client.posts.list(:forum => forum_name, :limit => 5)

        File.open(cache_file_path,"w") do |f|
          f.write(disqus_data.to_json)
        end
      end 

      # Output the HTML elements according to the configuration
      output = "<ul class='#{ul_class}'>"

      for response in disqus_data["response"]
        avatar = response["author"]["avatar"]["small"]["permalink"]
        message = response["raw_message"]

        output << "<li><p><img class='#{image_class}' src='#{avatar}'></img>#{message}<p></li>\n"
      end

      "#{output}\n<ul>"

    end
  end
end

Liquid::Template.register_tag('disqus_comments', Jekyll::DisqussionCommentsTag)