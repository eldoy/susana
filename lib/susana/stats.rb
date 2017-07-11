# Print boot time info and measure load times

module Susana
  class Stats

    def initialize(env)
      @enabled = env == 'development'
      @t = Time.now

      # Bundler setup: https://git.io/vXbws
      $bundle_timer = false
    end

    def welcome
      return unless @enabled
      puts %{\n * S U S A N A *}
    end

    def gems
      return unless @enabled
      @t2 = Time.now
      puts "\n Load gems: #{(@t2 - @t).round(3)}"
    end

    def app
      return unless @enabled
      @t3 = Time.now
      puts " Load code: #{(@t3 - @t2).round(3)}"
      puts " Load done: #{(@t3 - @t).round(3)}\n\n"
    end

  end
end
