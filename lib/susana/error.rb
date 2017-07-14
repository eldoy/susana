module Susana
  class Error

    attr_accessor :r

    # Init errors
    def initialize
      self.r = HashWithIndifferentAccess.new{|h, k| h[k] = []}
    end

    # Access field
    def [](key)
      r[key]
    end

    # Join fields
    def join(key, sep = ', ')
      r[key].join(sep)
    end

    # Add errors
    def add(key, message)
      r[key] << message
    end

    # Short messages
    def short(sep = ', ')
      r.map{|k, v| v}.flatten.join(sep)
    end

    # Flat errors
    def flat(sep = ', ')
      r.map{|k, v| {k => v.join(sep)}}
    end

    # Get full messages
    def full; r; end

    # Any?
    def any?; r.any?; end

    # Empty?
    def empty?; r.empty?; end

  end
end
