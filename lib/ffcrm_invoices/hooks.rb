
## load hooksn
ActiveSupport.on_load(:before_initialize) do
  hooks_directory = File.expand_path("../hooks", __FILE__)
  Dir["#{hooks_directory}/*_hook.rb"].each do|f|
    require f
    puts f
  end
end


##  special hook to make big brother fatfreecrm to read ffcrm invoice settings.yml, too.
ActiveSupport.on_load(:fat_free_crm_setting) do
  setting_files = [ FfcrmInvoices::Engine.root.join('config', 'settings.yml')]
  setting_files.each do |settings_file|
    Setting.load_settings_from_yaml(settings_file) if File.exist?(settings_file)
  end
end


## cancan ability hook for invoice
ActiveSupport.on_load(:fat_free_crm_ability) do
  alias :intialize_before_invoice :initialize 
  def initialize(user)
    initialize_before_invoice(user)
    can :manage, [Invoice], :access => 'Public'
    can :manage, [Invoice], :user_id => user.id
  end
end


## 


##
