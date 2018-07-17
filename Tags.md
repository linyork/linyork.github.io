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
    <a class="post-tag" onclick="changeBlock('{{ tag[0] | slugify }}')">
      {{ tag[0] }} - {{ tag[1].size }} 篇
    </a>
    {% endfor %}
  </div>
  <hr/>
  <div class="tags-expo-section">
    {% for tag in site.tags %}
      <div class="post-tag-block" id="{{ tag[0] | slugify }}-block" style="display:none;">
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
      </div>
    {% endfor %}
  </div>
</div>
<script type="text/javascript" src="{{ site.baseurl }}/public/js/tag-block-change.js" ></script>