---
layout: default
title: "If you forget a password - Lokka"
breadcrumb: "If you forget a password"
date: 
---

## If you forget a password

<p>You can update password using IRB or Heroku Console.</p>
<h3>Local</h3>
<pre><code>$ bundle exec irb -r ./init.rb
&gt; Lokka::Database.new.conenct</code></pre><h3>Heroku</h3>
<pre><code>$ heroku console</code></pre>
<h3>Update password directly</h3>
<pre><code>&gt; User.first(:name =&gt; 'test').
    update!(:password =&gt; 'lokka', :password_confirmation =&gt; 'lokka')</pre>	Page	2011-08-09 06:16:09

<p class="date"></p>
