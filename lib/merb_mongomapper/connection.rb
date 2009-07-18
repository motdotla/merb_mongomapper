module Merb
  module MongoMapper
    
    class << self
      
      def config_file() Merb.dir_for(:config) / "mongomapper.yml" end
      def sample_dest() Merb.dir_for(:config) / "mongomapper.yml.sample" end
      def sample_source() File.dirname(__FILE__) / "mongomapper.yml.sample" end
      
      def connect
        begin
          configure_db
          Merb.logger.info "MongoMapper connected to mongodb #{::MongoMapper.db.uri}"
        rescue => e
          uri = ::MongoMapper.db ? ::MongoMapper.db.uri : "<initialization error>"
          Merb.logger.fatal "MongoMapper could not connect to mongodb at #{uri} \n\tRoot cause:#{e}\n#{e.backtrace.join("\n")}"
          exit(1)
        end
      end
      
      def configure_db
        if File.exists?(config_file)        
          full_config = Erubis.load_yaml_file(config_file)
          config = full_config[Merb.environment.to_sym]
          config[:logger] = Merb.logger
          ::MongoMapper.configure(config)
          ::MongoMapper.use_db(config[:db])
        else
          copy_sample_config
          Merb.logger.error! "No mongomapper.yml file found in #{Merb.root}/config."
          Merb.logger.error! "A sample file was created called mongomapper.yml.sample for you to copy and edit."
          exit(1)
        end          
      end

      def copy_sample_config
        FileUtils.cp sample_source, sample_dest unless File.exists?(sample_dest)
      end
                  
    end
    
  end
end
