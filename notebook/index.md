---
title: "About me and this site"
layout: default
---

# Notebook Index

An index of the notes on the site.

{% for page in site.pages %}

 - {{ page.url }}

{% endfor %}

