# Listen for file changes
if App.env == 'development'
  listener = Listen.to(App.root) do |m, a, r|
    # puts "M: #{m}\nA: #{a}\nR: #{r}"
    (m + a + r).each do |f|
      case File.extname(f)
      when '.rb'
        $LOADED_FEATURES.delete(f)
        require f unless r.include?(f)
      when '.yml'
      end
    end
  end
  listener.start
end
