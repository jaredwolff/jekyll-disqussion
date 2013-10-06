require 'jekyll'
require 'jekyll/post'
require 'rubygems'
require 'disqussion'
require 'json'
require 'date'

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

      # Set the refresh rate in minutes (how long the program will wait before writing a new file)
      refresh_rate = settings['refresh_rate'] || 60

      #configuration options needed
      limit = settings['limit'] || 5
      ul_class = settings['ul_class'] || ""
      image_class = settings['image_class'] || ""
      preview_size = settings['preview_size'] || 10

      # If the directory doesn't exist lets make it
      if not Dir.exist?(cache_directory)
        Dir.mkdir(cache_directory) 
      end

      # Now lets check for the cache file and how old it is
      if File.exist?(cache_file_path) and ((Time.now - File.mtime(cache_file_path))/60 < refresh_rate)
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

        disqus_data = Disqussion::Client.posts.list(:related => "thread", :forum => forum_name, :limit => limit)

        File.open(cache_file_path,"w") do |f|
          f.write(disqus_data.to_json)
        end
      end 

      # Output the HTML elements according to the configuration
      output = "<ul class='#{ul_class}'>"

      for response in disqus_data["response"]
        avatar = response["author"]["avatar"]["small"]["permalink"]
        name = response["author"]["name"]
        message = response["raw_message"]
        trunk_message = message.split(/\s+/, preview_size+1)[0...preview_size].join(' ') + "..."
        profile_url = response["author"]["profile_url"]
        thread_link = response["thread"]["link"]

        output << "<li class='side-bar-recent-post-li'>
                      <div class='side-bar-recent-post-img'><img src='#{avatar}'></img></div>
                      <div class='side-bar-recent-post-content'>
                        <div class='side-bar-recent-post-username'><a href='#{profile_url}'>#{name}</a></div>
                        <div><a href='#{thread_link}'>#{trunk_message}</a></div>
                      </div>
                   </li>\n"
      end

      "#{output}\n<ul>"

    end
  end
end

Liquid::Template.register_tag('disqus_comments', Jekyll::DisqussionCommentsTag)