require "spec_helper"

module ProjectScout
  describe Dir do
    it "should define a shortcut initializer" do
      ProjectScout::Dir("/").should be_a_kind_of(ProjectScout::Dir)
    end

    describe "an instance" do
      before do
        File.stub! :directory? => true
      end
      subject { Dir.new "/parent" }

      describe "#ruby_rails?" do
        it "should be true if the directory is the root of a rails project" do
          File.should_receive(:exists?).with("/parent/config/environment.rb").and_return true
          subject.should be_a_ruby_rails_project
        end

        it "should be false if the directory is not the root of a rails project" do
          File.should_receive(:exists?).with("/parent/config/environment.rb").and_return false
          subject.should_not be_a_ruby_rails_project
        end

        it "should check if the path contains config/environment.rb" do
          subject.should_receive(:contains?).with("config/environment.rb")
          subject.ruby_rails_project?
        end
      end

      specify "#ruby_cucumber? should check if the path contains features/env.rb" do
        subject.should_receive(:contains?).with("features/env.rb")
        subject.ruby_cucumber_project?
      end

      specify "#ruby_spec? should check if the path contains spec/spec_helper.rb" do
        subject.should_receive(:contains?).with("spec/spec_helper.rb")
        subject.ruby_rspec_project?
      end

      specify "#ruby? should check if the path is any sort of ruby project?" do
        subject.should_receive :ruby_rspec?
        subject.should_receive :ruby_cucumber?
        subject.should_receive :ruby_rails?
        subject.ruby_project?
      end

    end
  end
end
