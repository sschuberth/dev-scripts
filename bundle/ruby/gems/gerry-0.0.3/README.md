# gerry[![Build Status](https://travis-ci.org/trumant/gerry.svg)][travis]

Simple Ruby wrapper for the Gerrit Code Review REST-API.

![Gary from spongebob square pants](http://en.spongepedia.org/images/3/37/Garry.jpg)

[travis]: https://travis-ci.org/trumant/gerry

## Documentation
[http://rdoc.info/github/trumant/gerry][documentation]

[documentation]: http://rdoc.info/github/trumant/gerry

## Install
```
bundle
bundle exec rake install
```

## Examples
### Get the global capabilities
```ruby
client = Gerry.new('https://review')
client.account_capabilities
=> {"queryLimit"=>{"min"=>0, "max"=>250}}
```

### List projects
```ruby
client = Gerry.new('https://review')
client.projects
=> { "awesome"=>{ "description"=>"Awesome project"}}
```

### List open changes
```ruby
client = Gerry.new('https://review')
client.changes(['q=is:open'])
=> [{"project"=>"awesome", "branch"=>"master", "id"=>"Ibfedd978...."}]
```

## Licence
The MIT Licence

Copyright (c) Fabian Mettler, Andrew Erickson, Travis Truman

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## References
[http://code.google.com/p/gerrit/][gerrit]

[gerrit]: http://code.google.com/p/gerrit/

[https://gerrit-review.googlesource.com/Documentation/rest-api.html][apidocumentation]

[apidocumentation]: https://gerrit-review.googlesource.com/Documentation/rest-api.html
