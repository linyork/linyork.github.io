---
layout: page
title: Archives
---

<section id="archive">
  <h3>今年的文章</h3>
  {%for post in site.posts %}
    {% unless post.next %}
      <ul class="post-list">
    {% else %}
      {% capture year %}{{ post.date | date: '%Y' }}{% endcapture %}
      {% capture nyear %}{{ post.next.date | date: '%Y' }}{% endcapture %}
      {% if year != nyear %}
        </ul>
        <h3>{{ post.date | date: '%Y' }}</h3>
        <ul class="post-list">
      {% endif %}
    {% endunless %}
      <li>{{ post.date | date:"%b"}} <a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}<span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}"></time></span></a> {{ post.date | date: "%b %d, %Y" }}</li>
  {% endfor %}
  </ul>
</section>

