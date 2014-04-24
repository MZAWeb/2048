lib_path = File.expand_path(File.dirname(__FILE__))
Dir[lib_path + "/**/*.rb"].each { |file| require file }
