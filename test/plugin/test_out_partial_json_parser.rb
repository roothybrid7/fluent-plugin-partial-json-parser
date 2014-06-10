# coding: utf-8
require 'helper'

class PartialJSONParserTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    remove_prefix test
    add_prefix reemit
    keys buz,no_field
  ]

  def create_driver(conf=CONFIG,tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::PartialJSONParser, tag).configure(conf)
  end

  def test_configure
    assert_raise(Fluent::ConfigError) {
      d = create_driver('')
    }
    assert_raise(Fluent::ConfigError) {
      d = create_driver %[
        keys bar,buz
      ]
    }
    assert_raise(Fluent::ConfigError) {
      d = create_driver %[
        tag foo
        add_prefix test
        keys bar,buz
      ]
    }
    assert_raise(Fluent::ConfigError) {
      d = create_driver %[
        tag foo
        remove_prefix test
        keys bar,buz
      ]
    }
    assert_raise(Fluent::ConfigError) {
      d = create_driver %[
        tag foo
      ]
    }
    assert_nothing_raised(Fluent::ConfigError) {
      d = create_driver %[
        tag foo
        keys bar,buz
      ]
    }
    assert_nothing_raised(Fluent::ConfigError) {
      d = create_driver %[
        add_prefix foo
        keys bar,buz
      ]
    }
    assert_nothing_raised(Fluent::ConfigError) {
      d = create_driver %[
        remove_prefix foo
        keys bar,buz
      ]
    }
    assert_nothing_raised(Fluent::ConfigError) {
      d = create_driver %[
        remove_prefix test
        add_prefix foo
        keys bar,buz
      ]
    }
  end

  def test_emit
    d = create_driver(CONFIG, 'test.out')
    time = Time.parse("2012-01-02 13:14:15").to_i
    d.run do
      d.emit({'foo' => 1, 'bar' => 'a'}, time)
      d.emit({'foo' => 2, 'bar' => 'b', 'buz' => '{"a":{"b":"message"},"id":20}'}, time)
      d.emit({'foo' => 3, 'bar' => 'c', 'buz' => '{"a":{"b":"message2"},"id":21}'}, time)
    end
    emits = d.emits
    assert_equal 3, emits.length

    first = emits[1]
    assert_equal 'reemit.out', first[0]
    first_record = first[2]
    assert_equal 2, first_record['foo']
    assert_equal 'b', first_record['bar']
    assert_equal 'message', first_record['buz']['a']['b']
    assert_equal 20, first_record['buz']['id']
  end
end
