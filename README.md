# DoomwadBot

Mastodon bot that posts images of Doom levels from popular Wads.

## How it works.

All the heavy lifting is done by [wad2image](https://selliott.org/utilities/wad2image) an excellent Python command-line tool that is capable of creating images of Doom and Doom 2 levesl within
WAD files.

While the bot is written in Ruby we just shell out to `wad2image` to do the image generation, then
use that output as the basis for posting an update.

The bot is responsible for:

- selecting the WAD to process, based on a list of WADs compiled from [Cacoward winners](https://www.doomworld.com/cacowards/)
- fetching metadata, including the download link from [the id2games archive](https://www.doomworld.com/idgames/) API
- downloading and unpacking the WAD
- running `wad2image`
- then uploading media and posting an update to Mastodon

## Installation

Checkout the code and then:

```
bundle install
rake install
```

The rake install task will:

- setup necessary directories
- download the IWADs from the Internet Archive (to save you finding your own copy, obviously)
- checking out `wad2image`

You'll need to add `MASTODON_BASE_URL` and `MASTODON_BEARER_TOKEN` to your `.env`

## Limitations

Not all Doom WADs have custom maps, so we just ignore those.

Only works with WADs. There doesn't seem to be a standard way to organise [a PK3 file](https://doomwiki.org/wiki/PK3).

`wad2image` is unable to extract images from some WADS. Possibly bug in the library or some non-standard behaviour.

## Planned Improvements

The intention is to make the bot more sophisticated by:

- Improve the posts to add a bit more metadata, if available. E.g. add idgames rating
- adding additional WAD lists, e.g. [Dean of Doom reviews](https://doomwiki.org/wiki/Dean_of_Doom) and [Top 100 WADS of all time](https://www.doomworld.com/10years/bestwads/)
- ability to post levels from a specific WAD via the command-line
- make more use of the styling supported by wad2image. Currently just randomly selecting adding sprites vs dots, but we could maybe do more. Describing the colour scheme somewhere would be helpful.
- making it interactive to allow people to request levels via Mastodon. These will go on a queue for later processing
- giving the bot a 'memory' to reduce likelihood of posting same levels multiple times
