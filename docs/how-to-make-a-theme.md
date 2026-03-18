---
layout: default
title: "How to make a theme - Lokka"
breadcrumb: "How to make a theme"
date: 
---

## How to make a theme

<p>First, make <code>public/theme/<i>THEME NAME</i></code> directory.</p>

<p>Copying existing theme is no probrem. But now, Let's make theme from nothing.</p>

<h3>Making theme directory</h3>

<p>exampleディレクトリの作成</p>

<p><a href="https://www.flickr.com/photos/komagata/5404610295/" title="theme by komagata, on Flickr"><img src="https://farm6.static.flickr.com/5293/5404610295_b18c77eb4a.jpg" width="500" height="284" alt="theme"></a></p>

<p>テーマのディレクトリの中にテンプレートファイルを作成します。テンプレートの形式は複数から選べますが、一番簡単なerbで作ってみます。</p>

<p>Lokkaのテーマに最低限必要なテンプレートは下記の二つだけです。</p><ul><li>entry.erb: 個別(Individual)ページのテンプレート</li><li>entries.erb: 一覧(List)ページのテンプレート</li></ul><h3>Making template for individual page</h3>

<p>まずは個別ページのテンプレートを書いてみます。</p>

<p><a href="https://www.flickr.com/photos/komagata/5405243042/" title="entry.erb — untitled by komagata, on Flickr"><img src="https://farm6.static.flickr.com/5297/5405243042_4fc6a7d96e.jpg" width="500" height="307" alt="entry.erb — untitled"></a></p>

<p>exampleテーマを使うように設定します。themeディレクトリにexampleディレクトリを作成した時点でテーマが認識されているので、管理画面の"テーマ"から"example"のテーマを選択します。</p>

<p><a href="https://www.flickr.com/photos/komagata/5405248068/" title="Test Site - Lokka by komagata, on Flickr"><img src="https://farm6.static.flickr.com/5133/5405248068_a1e1cb8d53.jpg" width="500" height="370" alt="Test Site - Lokka"></a></p>

<p>そして、個別ページを見てみましょう。(最初から1エントリーある筈なので http://localhost:9646/1 にアクセスします。)</p>

<p><a href="https://www.flickr.com/photos/komagata/5404644687/" title="Example Individual Page by komagata, on Flickr"><img src="https://farm6.static.flickr.com/5135/5404644687_c8b8724100.jpg" width="500" height="370" alt="Example Individual Page"></a></p>

<p>単なるHTMLですが、ちゃんと表示されました。</p>

<p>しかし、静的なHTMLを表示するだけではつまらないのでサイトのタイトルを表示してみましょう。</p>

<p><a href="https://www.flickr.com/photos/komagata/5404661147/" title="entry.erb — untitled by komagata, on Flickr"><img src="https://farm6.static.flickr.com/5100/5404661147_e719a90115.jpg" width="482" height="374" alt="entry.erb — untitled"></a></p>

<p>h1タグの部分にサイトのタイトルを表示するように変更しました。&lt;% と %&gt;を囲うのがerb形式のテンプレートの記法です。&lt;%= %&gt;のように=が最初に付くと内容を表示するという意味になります。(これはphp/wordpressの&lt;?php echo ?&gt;と同じです。)</p>

<p>また http://localhost:9646/1 にアクセスして確認してみましょう。</p>

<p><a href="https://www.flickr.com/photos/komagata/5405274724/" title="Example Individual Page by komagata, on Flickr"><img src="https://farm6.static.flickr.com/5019/5405274724_9d67555e41.jpg" width="500" height="370" alt="Example Individual Page"></a></p>

<p>サイトのタイトルが表示されました。この内容は管理画面の"設定" &gt; "タイトル" で変更することが出来ます。同じようにサイトの詳細も &lt;%= @site.description %&gt;と書けば表示されます。</p>

<p>今度は個別ページなので、エントリーの内容を表示してみましょう。</p>

<p><a href="https://www.flickr.com/photos/komagata/5404686803/" title="entry.erb — untitled by komagata, on Flickr"><img src="https://farm6.static.flickr.com/5178/5404686803_c42169b9c8.jpg" width="482" height="374" alt="entry.erb — untitled"></a></p>

<p>http://localhost:9646/1 というURLからわかるように、IDが1のエントリーを表示するためのテンプレート内容になっています。</p>

<p>上記URLから判断して、IDが1のエントリーが@entryという変数の中に自動的に入っているので、@entry.titleや@entry.bodyでそれぞれエントリーのタイトルと本文が取り出せます。</p>

<p><a href="https://www.flickr.com/photos/komagata/5404696749/" title="Example Individual Page by komagata, on Flickr"><img src="https://farm6.static.flickr.com/5214/5404696749_c883449bc1.jpg" width="500" height="370" alt="Example Individual Page"></a></p>

<p>表示されました。</p>

<h3>Making template for listing page</h3>

<p>一覧ページのテンプレートを作る前に、エントリーが一個だけでは一覧になっているかわからないので管理画面の"投稿" &gt; "登録" から幾つか適当に投稿(Post)を登録しておきます。</p>

<p>entries.erbというファイル名で一覧のページのテンプレートを作成します。</p>

<p><a href="https://www.flickr.com/photos/komagata/5405443776/" title="entries.erb — untitled by komagata, on Flickr"><img src="https://farm6.static.flickr.com/5095/5405443776_73ebb7d308.jpg" width="500" height="312" alt="entries.erb — untitled"></a></p>

<p>一覧は個別より少し複雑です。&lt;% @posts.each do |post| %&gt;から&lt;% end %&gt;の書き方に注目して下さい。do ~ endは一組になっていて（ブロックと言います）、@posts.each do ~ end は@postsの個数分だけdo ~ endを繰り返すという構文です。投稿(Post)が3個あれば3回繰り返されます。</p>

<p>結果は下記のように表示されます。</p>

<p><a href="https://www.flickr.com/photos/komagata/5404734539/" title="Example List Page by komagata, on Flickr"><img src="https://farm6.static.flickr.com/5056/5404734539_bcffd82763.jpg" width="500" height="370" alt="Example List Page"></a></p>

<h3>How to use images, css and other</h3>

<p>画像やCSS、Javascriptといった外部リソースはテーマフォルダに含めることができます。</p>

<p>例えば、example/logo.png は &lt;img src="/theme/example/logo.png"&gt; のようにテンプレート中で指定できます。下記のようにディレクトリを作っても構いません。</p>

<pre>example/
 images/
  logo.png
 stylesheets/
  style.css
 javascripts/
  jquery.js</pre>

<p>また、テーマまでのパスは下記のように書くこともできます。</p>

<pre><code>&lt;img src="&lt;%= @theme.path %&gt;/logo.png" /&gt;</code></pre>

<p>テーマ作成に最低限の知識はこれだけです。Lokkaにはその他に柔軟なテンプレートタイプとテーマAPIを持っていますが、それを以下で紹介したいと思います。</p>

<h3>Advanced functions for theme</h3>

<p>最低限のテーマの作り方は紹介しました。以下は無くてもいいけど使うと便利なテンプレートタイプについて紹介します。</p>

<p>Lokkaにはデフォルトのentry, entries以外に様々なテンプレートタイプがあります。テンプレートは一覧、個別、その他のどれかに分類されます。</p>

<h3>Template types</h3>

<p>list</p>

<ul>
<li>index: トップページのテンプレート</li>
<li>category: カテゴリー別の一覧ページのテンプレート</li>
<li>tag: タグ別の一覧ページのテンプレート</li>
<li>yearly: 年別の一覧ページのテンプレート</li>
<li>monthly: 月別の一覧ページのテンプレート</li>
<li>search: 検索結果の一覧ページのテンプレート</li>
<li>entries: 一覧ページのテンプレート。上記のテンプレートが無い場合に使われる。</li>
</ul>

<p>individual</p>

<ul>
<li>post: 投稿(Post)の個別ページのテンプレート</li>
<li>page: ページ(Page)の個別ページのテンプレート</li>
<li>entry: 個別ページのテンプレート。上記のテンプレートが無い場合に使われる。</li>
</ul>

<p>other</p>

<ul>
<li>partial: テンプレートの一部分を共有するテンプレート</li>
<li>layout: テンプレートの外枠を共有するテンプレート</li>
</ul>

<h3>List template</h3>

<p>一覧はentries、個別はentryというテンプレートがありますが、例えば一覧で"検索結果だけに必要なもの"があった場合、entriesの中がごちゃごちゃしてしまうのでsearchという名前でテンプレートを作っておくと、検索結果の場合はそちらが優先して使われます。</p>

<h3>Individual template</h3>

<p>同じようにentryとpostというテンプレートがあった場合投稿(Post)の場合はpostが優先的に表示されます。投稿とそれ以外で別の内容にしたい時に便利です。</p>

<p>どのテンプレートが選ばれるかはURLで決まります。実際には厳密なルールがありますが長くなるので代表的な例を紹介します。</p>

<ul>
<li>index: /</li>
<li>category: /category/foo/</li>
<li>tag: /tag/foo/</li>
<li>yearly: /2011/</li>
<li>monthly: /2011/01/</li>
<li>search: /search/foo/</li>
<li>post: /1</li>
<li>page: /2</li>
</ul>

<p>(postやpageやcategoryはIDの他にスラッグと呼ばれる自由なURLを持つことができます。そちらでもアクセスすることも可能です。)</p>

<p>上記以外に特殊なテンプレートタイプが存在します。それがpartialとlayoutです。</p>

<h3>Partial template</h3>

<p>partialは複数のテンプレートで共通の部分等を別ファイルとして作成して共有するためのテンプレートです。好きな名前で作成することができます。</p>

<p>例えば、Copyright部分をpartialテンプレートとして下記のように作成し、別のテンプレートから読み込む事ができます。</p>

<p>copyright.erb:</p>

<pre><code>&lt;p&gt;Copyright FJORD, LLC&lt;/p&gt;</code></pre>

<p>entries.erb:</p>

<pre><code>(省略)
&lt;%= partial 'copyright' %&gt;</code></pre>

<p>entry.erb:</p>

<pre><code>(省略)
&lt;%= partial 'copyright' %&gt;</code></pre>

<p>同じ内容が複数のテンプレートで出てくる場合にpartialを使うと楽でしょう。</p><h3>Layout template</h3>

<p>もう一つのlayoutテンプレートはpartialとは逆に、テンプレートの一部分を共有するのではなく、外枠の殆どを共有するイメージです。</p>

<p>layout.erb:</p>

<pre><code>&lt;h1 id="header"&gt;Title&lt;/h1&gt;
&lt;%= yield %&gt;
&lt;div id="footer"&gt;Powered by Lokka&lt;/div&gt;</code></pre>

<p>entry.erb:</p>

<pre><code>&lt;h2&gt;Post Title 1&lt;/h2&gt;
&lt;div class="body"&gt;body ...&lt;/div&gt;</code></pre>

<p>yieldの部分にentryやentriesのテンプレートの結果が全部入るイメージです。layoutテンプレートはWordPressなどには無い機能なので多少取っ付きづらいですが、テンプレートの大部分を共有できる非常に便利な機能で、上手く使うとテーマコーディングが大幅に楽になります。数多くのフレームワークに採用されている機能なので是非とも活用してみてください。</p>	Page	2011-07-24 00:10:11

<p class="date"></p>
