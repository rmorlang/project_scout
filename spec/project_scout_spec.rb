require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ProjectScout" do
  describe "scan" do
    before do
      @ps_dir = mock("ProjectScout::Dir").as_null_object
      ProjectScout.stub!(:Dir).and_return(@ps_dir)

      File.stub! :directory? => true
      File.stub! :expand_path do |param|
        case param 
        when "/some/dir"
          "/some/dir"
        when "/some/dir/.."
          "/"
        end
      end
    end
      
    it "should check to make sure the specified path exists" do
      dir = "/non/existent/directory"
      File.should_receive(:directory?).with(dir).and_return false
      lambda {
        ProjectScout.scan dir
      }.should raise_error(/does not exist/)
    end

    describe "default behaviour" do
      it "should recurse upward" do
        File.should_receive(:expand_path).with("/a/b/c").ordered.and_return("/a/b/c")

        File.should_receive(:expand_path).with("/a/b/c/..").ordered.and_return("/a/b")
        File.should_receive(:expand_path).with("/a/b/..").ordered.and_return("/a")
        File.should_receive(:expand_path).with("/a/..").ordered.and_return("/")
        File.should_not_receive(:expand_path).with("/..")

        ProjectScout.scan "/a/b/c"
      end

      it "should scan for any kind of Ruby project" do
        ProjectScout.should_receive(:Dir).with("/some/dir").and_return(@ps_dir)
        @ps_dir.should_receive(:ruby_project?)
        ProjectScout.scan "/some/dir"        
      end
    end

    it "should allow the kinds of projects scanned for to be specified" do
      @ps_dir.should_not_receive :ruby_project?
      @ps_dir.should_receive :smurf_project?
      @ps_dir.should_receive :fraggle_project?
      ProjectScout.scan "/some/dir", :for => [ :smurf, :fraggle ]
    end

    it "should return the matching directory if a project directory is found" do
      @ps_dir.stub!(:ruby_project?).and_return(true)
      ProjectScout.scan("/some/dir").should == "/some/dir"
    end

    it "should return nil if no matching directory is found" do
      @ps_dir.stub!(:ruby_project?).and_return(false)
      ProjectScout.scan("/some/dir").should be_nil
    end
  end
end

#ProjectScout.scan "/a/directory", :without_recursion, :for => :ruby_rails
