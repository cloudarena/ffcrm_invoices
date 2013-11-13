

ActiveSupport.on_load(:before_initialize) do
  hooks_directory = File.expand_path("../hooks", __FILE__)
  Dir["#{hooks_directory}/*_hook.rb"].each do|f|
    require f
    puts f
  end
end

