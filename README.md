crowdsourced temporary HR database
----------------------------------

Scrapes data from dokuwiki at http://www.pirati.cz/lide/ namespace gathering data about people if they provide any in a dokuwiki's markdown tables

example of table data in dokuwiki's source:
```
| nickname | klip |
| mail | tomas@klapka.cz |
| jabber | tomas@klapka.cz |
```

URL API
-------

/ - lists all pages
/tag/<tag> - shows data for page with tag <tag>
/search/<string> - searches for string in all data and lists matching pages
