---
layout: page
title: 歸檔
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
      <li>
        <div class="post-tag" style="background:#ccc">
            {{ post.date | date: "%m-%d" }}
        </div>
        <a href="{{ site.baseurl }}{{ post.url }}">
            {{ post.title }}
          <span class="entry-date">
            <time datetime="{{ post.date | date_to_xmlschema }}">
            </time>
          </span>
        </a>
      </li>
  {% endfor %}
  </ul>
</section>

