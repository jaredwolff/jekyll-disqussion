Jekyll Discussion
===========
**by jaredwolff**

The Jeyll Disqussion plugin uses the Ruby Disqus API to retrieve post data from Disqus.

# Installation

1. Add this repo as a submodule to your Jekyll Git project:

        git submodule add git@github.com:jaredwolff/jekyll-disqussion.git _plugins/jekyll_disqussion/

    Note: You can also copy **jekyll\_disqussion.rb** to _plugins/

2. Add the following fields to your _config.yml:

        disqus_commments:
          api_key:      <your API key here>
          api_secret:   <your API secret here>
          forum_name:   <your forum name here>
          limit:        3

    You can adjust **limit** to process a different number of posts.

# Usage

### Disqus Comments

Note: currently this plugin only has one piece of functionality. You can only recieve the latest posts from your forum.

Simply inclue the _{% disqus\_commments %}_ tag where you want the comments.

    <div class="side-bar-headline">Recent Comments</div>
      {% disqus_comments %}
    </div>

Every piece of html has it's own class and is completely styleable.

    <div class="side-bar-recent-comments text-left">
        <div class="side-bar-headline">
            Recent Comments
        </div>
        <ul class='disqussion-ul'>
            <li class='disqussion-li'>
                <div class='disqussion-img'>
                    <img src='https://disqus.com/api/users/avatars/jaredwolff_blog.jpg'>
                </div>
                <div class='disqussion-content'>
                    <div class='disqussion-user-name'>
                        <a href='http://disqus.com/jaredwolff_blog/'>Jared Wolff</a>
                    </div>
                    <div class='disqussion-thread-link'>
                        <a href='http://stage.rediruck.com/basics/2013/09/27/whats-your-plan-lacking/'>this is an amazing comment which has lots of words...</a>
                    </div>
                </div>
            </li>
        </ul>
    </div>

Classes include:

* disqussion-ul             -- the surrounding unordered list
* disqussion-li             -- each list item
* disqussion-img            -- the avatar image
* disqussion-content        -- the div containing the user-name and thread-link/description
* disqussion-user-name      -- the username of the post
* disqussion-thread-link    -- the link and description of the post

Here is an example of how i'm styling **disqus\_comments**

    /* Disqussion */
    
    .disqussion-ul {
      list-style: none;
      width:273px;
      margin: 0 0 10px 5px;
    }
    
    .disqussion-img {
      margin: 5px;
      float: left;
      width: 50px;
      height: 50px;
    }
    
    .disqussion-content {
      margin: 0 0 0 2px;
      width: 210px;
      float: right;
    }
    
    .disqussion-li {
      margin: 2px 0 2px 0;
      height: 60px;
      clear:both;
    }

#Notes

Have an idea to make it better? Feel free to share! (Pull requests are encouraged.)

#License

See included license file.

