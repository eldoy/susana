# Listen for file changes
if App.env == 'development'

  # Boot file location
  boot = "#{App.root}/config/boot.rb"

  # Set up listener
  listener = Listen.to(App.root) do |m, a, r|
    # puts "M: #{m}\nA: #{a}\nR: #{r}"
    (m + a + r).each do |f|
      case File.extname(f)
      when '.rb'
        # Reload ruby file if changed
        $LOADED_FEATURES.delete(f)
        require f unless r.include?(f)
      when '.yml'
        # Reboot if yaml file changed
        $LOADED_FEATURES.delete(boot)
        require boot
      end
    end
  end

  # Start listener
  listener.start
end
