# coding: utf-8

module Fluent
  class PartialJSONParser < Output
    Plugin.register_output('partial_json_parser', self)

    config_param :keys, :defaults => [] do |val|
      val.split(',')
    end
    config_param :tag, :string, :default => nil
    config_param :remove_tag_prefix, :string, :default => nil
    config_param :add_tag_prefix, :string, :default => nil

    include SetTagKeyMixin
    config_set_default :include_tag_key, false

    include SetTimeKeyMixin
    config_set_default :include_time_key, false

    unless method_defined?(:log)
      define_method(:log) { $log }
    end

    def initialize
      super
    end

    def configure(conf)
      super
      if @tag.nil? and @remove_tag_prefix.nil? and @add_tag_prefix.nil?
        raise ConfigError, "partial_json_parser: any of `tag`, `remove_tag_prefix` and `add_tag_prefix` is required"
      end
      if @tag and (@remove_tag_prefix or @add_tag_prefix)
        raise ConfigError, "both of `tag` and `remove_tag_prefix/add_tag_prefix` must not be specified"
      end
      if @remove_tag_prefix
        @removed_prefix = @remove_tag_prefix.chomp('.') + '.'
        @removed_length = @removed_prefix.length
      end
      @added_prefix = @add_tag_prefix.chomp('.') + '.' if @add_tag_prefix
    end

    def emit(tag, es, chain)
      if @tag
        tag = @tag
      else
        tag = tag[@removed_length..-1] if @remove_tag_prefix and tag.start_with?(@removed_prefix)
        tag = @added_prefix + tag if @add_tag_prefix
      end
      es.each do |time, record|
        record = parse(record)
        filter_record(tag, time, record)  # Fluent mixin processing
        Engine.emit(tag, time, record)
      end
      chain.next
    rescue => e
      # JSON parse error, etc.
      log.warn "partial_json_parser: #{e.class} #{e.message} #{e.backtrace.first}"
    end

    def parse(record)
      @keys.each do |key|
        value = record[key]
        if value
          parsed_value = Yajl::Parser.parse(value)
          record[key] = parsed_value
        end
      end
      record
    end
  end
end
