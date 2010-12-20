module ProjectScout

  # This is a helper class with a bit of syntactical magic. Want to know if
  # /home/user/bubbles is a Rails project?
  #
  #   ProjectScout::Dir("/home/user/bubbles").ruby_rails_project?
  #
  # Want to know if it's any sort of Ruby project?
  #
  #   ProjectScout::Dir("/home/user/bubbles").ruby_project?
  #
  class Dir
    attr_accessor :path

    def initialize(path)
      self.path = path
    end

    def git_repository?
      contains? ".git"
    end

    def ruby_cucumber?
      contains? "features/env.rb"
    end

    def ruby_rails?
      contains? "config/environment.rb"
    end

    def ruby_rspec?
      contains? "spec/spec_helper.rb"
    end

    def local_methods
      self.methods - self.class.methods
    end

    # Explanation of magic:
    #
    # 1) if a method is invoked with a "_project?" suffix, strip "_project"
    #    and call with the same arguments. Thus calling foo_bar_project?
    #    invokes foo_bar?
    #
    # 2) if a method invoked has no underscores in it, and local methods
    #    exist that start with the same string, invoke all of them and
    #    return true if and return true. Thus calling foo_project? when
    #    foo_bar_project? and foo_baz_project? exist will return true
    #    only if any of foo_bar_project? and foo_baz_project? return true.
    #
    def method_missing(method, *args)
      method = method.to_s
      if method.end_with? "_project?"
        method.sub! "_project", ""
        self.send method.to_sym, *args
      elsif !method.include?("_") && local_methods.find { |m| m.to_s.start_with? "#{method.chop}_" }
        project_methods = local_methods.find_all { |m| m.to_s.start_with? "#{method.chop}_" }
        project_methods.collect { |m| self.send m.to_s }.any?
      else
        raise NameError.new("undefined local variable or method '#{method}' for ProjectScout::Dir")
      end
    end

    def contains?(path_suffix)
      File.exists?(File.join(path, path_suffix))
    end
  end

  class << self
    def Dir(path)
      ProjectScout::Dir.new path
    end
  end
end
