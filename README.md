[![Build Status](https://travis-ci.org/rondale-sc/turbot.png)](https://travis-ci.org/rondale-sc/turbot)

```
 _______         _           _   
 |__   __|       | |         | |  
    | |_   _ _ __| |__   ___ | |_ 
    | | | | | '__| '_ \ / _ \| __|
    | | |_| | |  | |_) | (_) | |_ 
    |_|\__,_|_|  |_.__/ \___/ \__|
```

Turbot is a group effort to bring some entertainment to IRC.  It has been built for `#tamparb` by `#tamparb`.  Not in the Tampa area?  Don't worry you can easily get turbot up and running in your own channel. If you want to contribute to Turbot there is a section below that will help you do so.  

# Contributing

If you'd like to add a function or feature to turbot the reccomended way is to create a plugin.  (See some existing plugins below)

The main guidelines are as follows

1. Plugins should do __one__ thing.
2. Plugins should have a pretty simple matcher
3. Plugins should register themselves
  - This is mainly so that the `.help` command can stay current, but also enables turbot to do some pretty neat stuff.
4. Plugins need to be suffixed with `cinch_plugin.rb`.  This is how your plugin will be loaded.

Let's take a look at the TurbotInfo plugin. 

![turbot_info_example](https://raw.github.com/rondale-sc/turbot/master/assets/images/turbot_info_example.png)

1. Include `Cinch::Plugin` - This gives you access to all the methods that cinch provides.
2. Set your prefix.  All commands are prefixed so that they aren't triggered accidentally.  The `PREFIX` constant is set to `.` (dot).  You may override it if you wish, but going with the default is probably the best way to go.
3. `PluginHandler.add_plugin(self)` This is how your plugin is registered.  
4. Remember when we registered the plugin?  This is where we do some cool stuff with it.  Inside another plugin, the aptly named 'help' plugin, we iterate over all the plugins' `help` method and print out a listing of the available commands. See example output below.
5. This is where you write your matcher.  You do not need to include your prefix in your matcher as it is added there by cinch.
6. Where you do your cool plugin stuff.

If you want to contribute something other than a plugin.  Fork, code, submit pull req.  And we'll see what we can do.

# Plugins

Plugins:

#### Meetup

The Meetup plugin gives some basic information about the next Tampa Bay Ruby Brigade meeting.

![meetup_example](https://raw.github.com/rondale-sc/turbot/master/assets/images/meetup_example.png)

#### Duck Duck Go

This plugin lets you use Duck Duck Go's api in the IRC channel.  Check here for more info about possible commands: https://duckduckgo.com/api

![duck_duck_go_example](https://raw.github.com/rondale-sc/turbot/master/assets/images/duck_duck_go_example.png)

#### Chuck Norris

As its name implies.  This is all about Chuck Norris.  Observe:

![chuck_norris_example](https://raw.github.com/rondale-sc/turbot/master/assets/images/chuck_norris_example.png)

#### Cowsay

Renders output with Cowsay to IRC:

![cowsay_example](https://raw.github.com/rondale-sc/turbot/master/assets/images/cowsay_example.png)

#### Ferengi Rules

Dorkiest of all the plugins!

![ferengi_example](https://raw.github.com/rondale-sc/turbot/master/assets/images/ferengi_example.png)

#### Gem Search

Allows you to list a gem from rubygems.org.  `.gem <searchparam>` gives a list of potential matches.  `.gem info <searchparam>` gives info on specific gem.

![gem_search_example](https://raw.github.com/rondale-sc/turbot/master/assets/images/gem_search_example.png)

#### Github Status

This plugin reports the status of Github. (Duh).  It also periodically reports if the status is down.

![github_status_example](https://raw.github.com/rondale-sc/turbot/master/assets/images/github_status_example.png)

#### Help

This plugin reports all of the available commands.  To get further help, you can execute `.help <command name>`

![help_example](https://raw.github.com/rondale-sc/turbot/master/assets/images/help_example.png)

#### Make Me a Sandwich

Ask if Turbot will make you a sandwich.  I kinda doubt he will.

![make_me_a_sandwich_example](https://raw.github.com/rondale-sc/turbot/master/assets/images/make_me_a_sandwich_example.png)

#### Reddit Joke

Ask turbot to tell you a joke.

![reddit_joke_example](https://raw.github.com/rondale-sc/turbot/master/assets/images/reddit_joke_example.png)

#### URL Handler

Arguably the most useful plugin.  Prints short summary for a given url.  Does special formatting for youtube, twitter, et al.  

![url_handler_example](https://raw.github.com/rondale-sc/turbot/master/assets/images/url_handler_example.png)
