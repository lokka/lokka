---
layout: default
title: "Getting Started - Lokka"
breadcrumb: "Getting Started"
date: 
---

## Getting Started

<h3 id="unix">Mac OS X or UNIX</h3>

<pre><code>$ gem install bundler
$ git clone git://github.com/lokka/lokka.git
$ cd lokka
$ bundle install --without=production:<i>&lt;Databases which not use&gt;</i></code></pre>

<p>You can set in &lt;<i>Databases which not use</i>&gt;, mysql, postgresql, sqlite. For example, you can only use sqlite, following:</p>

<pre><code>$ bundle install --without=production:postgresql:mysql
</code></pre>

<pre><code>$ bundle exec rake db:setup
$ bundle exec rackup</code></pre>
<p>Web server will start at localhost. Access to http://localhost:9292/ . Default username and password are test / test.</p>

<h3>Windows</h3>

<ol>
<li>Install RubyInstaller for Windows.</li>
<li>Download lokka-win32-v<code>VERSION</code>.zip, extract and execute.</li>
<li>Access to http://localhost:9292/</li>
</ol>

<h3>Heroku</h3>

<p>Lokka is the best for Heroku.</p>

<pre><code>$ gem install heroku bundler
$ git clone git://github.com/lokka/lokka.git
$ cd lokka
$ heroku create mysite-by-lokka
$ git push heroku master
$ heroku run rake db:setup
$ heroku apps:open</code></pre>	Page	2010-09-08 20:08:23

<p class="date"></p>
