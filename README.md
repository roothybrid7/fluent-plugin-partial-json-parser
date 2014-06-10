# fluent-plugin-partial-json-parser

Fluentd ouput plugin to parse value with a JSON structure partial

[![Build Status](https://travis-ci.org/roothybrid7/fluent-plugin-partial-json-parser.svg)](https://travis-ci.org/roothybrid7/fluent-plugin-partial-json-parser) [![Gem Version](https://badge.fury.io/rb/fluent-plugin-partial-json-parser.svg)](http://badge.fury.io/rb/fluent-plugin-partial-json-parser) [![Dependency Status](https://gemnasium.com/roothybrid7/fluent-plugin-partial-json-parser.svg)](https://gemnasium.com/roothybrid7/fluent-plugin-partial-json-parser)

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-partial-json-parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ fluent-gem install fluent-plugin-partial-json-parser

## Usage

Now. Assuming that we have a below stream,

```
2014-05-28 12:18:30 +0900 test.out {"foo": 2, "bar": "b", "buz": "{\"a\":{\"b\":\"message\"},\"id\":20}"}
```

if describe config as below,

```
<match test.out>
    type partial_json_parser
    remove_tag_prefix test
    add_tag_prefix reemit
    keys buz,no_field
</match>
```

output a below stream.

```
2014-05-28 12:18:30 +0900 reemit.out {"foo": 2, "bar": "b", "buz": {"a": {"b": "message"}, "id": 20}}
```

## Options

### Parsing

`keys`: Specify record keys with JSON structure value for parsing.

### Tagging

`tag`, `remove_tag_prefix`, `add_tag_prefix`

## Other Information

Support `include_tag_key` and `include_time_key`.

```
<match test.out>
    type partial_json_parser
    # [...]
    include_tag_key true
    tag_key @log_name
    include_time_key true
    time_key @timestamp
</match>
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/fluent-plugin-partial-json-parser/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
