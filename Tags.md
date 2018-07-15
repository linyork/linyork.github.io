---
layout: page
title: 標籤
---

<div class="tags-expo">
  <div class="tags-expo-list">
    <div href="" class="post-tag" style="background:#ccc">
      All - {{ site.posts.size }} 篇
    </div>
    {% for tag in site.tags %}
    <a href="#{{ tag[0] | slugify }}" class="post-tag">
      {{ tag[0] }} - {{ tag[1].size }} 篇
    </a>
    {% endfor %}
  </div>
  <hr/>
  <div class="tags-expo-section">
    {% for tag in site.tags %}
    <h1 id="{{ tag[0] | slugify }}" class="post-tag">{{ tag[0] }}</h1>
    <ul class="tags-expo-posts">
      {% for post in tag[1] %}
        <a class="post-title" href="{{ site.baseurl }}{{ post.url }}">
          <li>
            {{ post.title }}
            <small class="post-date">
              {{ post.date | date: "%Y-%m-%d" }}
            </small>
          </li>
         </a>
      {% endfor %}
    </ul>
    {% endfor %}
  </div>
</div>