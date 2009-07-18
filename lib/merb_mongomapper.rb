# make sure we're running inside Merb
if defined?(Merb::Plugins)
  dependency "mongomapper"

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:merb_relaxdb] = {
    :chickens => false
  }
  
  Merb::BootLoader.before_app_loads do
  end
  
  Merb::BootLoader.after_app_loads do
  end
  
  Merb::Plugins.add_rakefiles "merb_mongomapper/merbtasks"
      
end
