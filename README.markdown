# FastProwl
## Ruby Prowl library that uses libcurl-multi for parallel requests

*FastProwl* is a Ruby library for interacting with the [Prowl API](http://prowl.weks.net/api.php) **using Typhoeus** (a libcurl-multi interface written in Ruby). It is inspired heavily by [August Lilleaas](http://august.lilleaas.net/)'s [ruby-prowl](http://github.com/augustl/ruby-prowl) library (the class method `FastProwl.add()` still works if you include this library instead).

*FastProwl* lets you queue up many Prowl API requests then make them concurrently, which is handy if you make a bunch of requests in quick succession. It was developed for [Prey Fetcher](http://preyfetcher.com), which sends too many notification requests to wait on blocking HTTP calls.

Please fork away and send me a pull request if you think you can make it better or whatnot.

## Installation

Install with RubyGems:

	gem install fastprowl

You'll need [Paul Dix](http://www.pauldix.net/)'s [Typhoeus](http://github.com/pauldix/typhoeus), which will automatically install as a dependency, but does require a reasonably current version of [libcurl](http://curl.haxx.se/libcurl/) installed. Check out the [Typhoeus README](http://github.com/pauldix/typhoeus/blob/master/README.textile) for more info. If you're having trouble getting that to work and just need a simple Prowl library with no dependancies/native extensions, check out [ruby-prowl](http://github.com/augustl/ruby-prowl).

## Usage

Pretty simple -- you can send single notifications without bothering with queuing and all that by using the class method `FastProwl.add()`:

	FastProwl.add(
      :apikey => 'valid_api_key',
      :application => 'Car Repair Shop',
      :event => 'Your car is now ready!',
      :description => 'We had to replace a part. Bring your credit card.'
    )

As mentioned, this is the same as using [ruby-prowl](http://github.com/augustl/ruby-prowl). It will return `true` on success; `false` otherwise.

If you want to send concurrent requests (presumably you do), create an instance object and use the `add()` method to queue up your requests. When all of your requests are ready, use the `run()` method to send all of your queued notifications:

	# You can put any attributes you want in the constructor
	# to save repeatedly supplying them when you call add()
	prowl = FastProwl.new(
	  :application => 'Car Repair Shop',
	  :event => 'Your car has been ready for ages!',
	  :description => 'Hurry up! Bring your credit card!'
	)
	
	users.each do |user|
	  prowl.add(
	    :apikey => user.prowl_apikey,
      )
	end
	
	prowl.run

You get the idea.

## License

This program is free software; it is distributed under an MIT-style License.

---

Copyright (c) 2011 [Matthew Riley MacPherson](http://lonelyvegan.com).
