Feeds `<title>Egg &amp; Spam</title><textarea>a &lt; <b></textarea>` to an HTMLParser subclass that prints events.

The injection removes the RCDATA branch (title/textarea) in `parse_starttag`, so these elements are no longer put in RCDATA mode.
Clean: `<b>` inside textarea is data, and charrefs are converted. Buggy: tags inside title/textarea are parsed as real tags.
