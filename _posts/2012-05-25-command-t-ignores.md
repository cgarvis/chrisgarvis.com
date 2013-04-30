---
layout: post
title:  "Leveling up in Vim - Command T Ignores"
date:   2012-5-25 12:51:27
categories: vim
---

I've been working on a node.js project for the past few weeks and the
"node_modules" directory has been killing Command-T. Today I was fed up and
decided to RTFM. And there it was "wildignore". I quickly opened up my .vimrc
and added:

{% highlight vim %}
set wildignore=*.o,*.obj,.git,node_modules/**
{% endhighlight %}

Don't know why I've waited this long.
