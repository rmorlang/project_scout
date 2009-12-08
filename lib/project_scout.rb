require 'project_scout/dir'

module ProjectScout
  class << self
    # Search recursively from the current working directory up for something
    # that looks like the root directory of a Ruby project.
    #
    # Returns the path to the first found project dir, if any. Nil otherwise.
    #
    # Stops looking when it reaches the top of the tree.
    #
    # By default, it will search for any kind of ruby project, but you can
    # specify exactly how to scan using the optional :for parameter. See
    # ProjectScout::Dir for the kinds of projects you can scan for.
    # 
    # Example Usage:
    # ProjectScout.scan "/some/path"
    # ProjectScout.scan "/some/path", :for => [ :ruby_rails, :ruby_cucumber ]
    #
    def scan(path, options = {})
      unless File.directory? path
        raise RuntimeError.new("#{path} does not exist")
      end

      path = File.expand_path(path)
      while path != '/'
        result = check_path path, options[:for]
        return result unless result.nil?
        path = File.expand_path(path + '/..')
      end
      nil
    end

    protected

    def check_path(path, check_for)
      check_for ||= [:ruby]
      check_for.to_a.each do |project_kind|
        result = Dir(path).send "#{project_kind}_project?".to_sym 
        return path if result == true
      end
      return nil
    end
  end
end

