# Rapid history extraction through non-destructive cache timing

From http://lcamtuf.coredump.cx/cachetime/chrome.html, this app determines whether a website has been visited recently by attempting to load static resources and determining whether the response time was fast enough to indicate a cache fetch as opposed to a network GET.

## Setup

- `bundle install`
- Run migrations
- `rake db:seed` to prepopulate apps table from `db/seeds/apps.yml`
- Start server with `rails server -p 3000`
- Navigate browser to `localhost:3000`

## Tests

- `rake db:test:prepare`
- `rspec spec`

## Notes

- The javascript mechanism is admittedly wonky, and configurations can be tinkered with in `cache_timing.js` to balance false negatives versus false positives, but there's not a universal setting that will work very reliably across different browsers and machines.
- Assets for caching are determined arbitrarily, by manually loading webpages several times and inspecting element to note what static assets are loaded in the most time, because they have more distinction between cache fetch time and network GET time.
- No tests for front-end :(
