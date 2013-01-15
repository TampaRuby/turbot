require 'spec_helper'

require_relative '../../plugin/make_me_a_sandwich_cinch_plugin.rb'

describe TurbotPlugins::MakeMeASandwich do
  subject(:plugin){ described_class.new(double.as_null_object) }
  let(:m) {double}

  context "user who hasn't sudoed yet" do
    before(:each) do
      m.stub(:user => "no_sudo_guy")
    end

    it "should return a 'make it yourself' reply when asking for a sandwich" do
      m.should_receive(:reply).with(TurbotPlugins::MakeMeASandwich::WHAT)

      plugin.make_me_a_sandwich(m)
    end

    it "should return a 'make it yourself' reply when asking for a sandwich a second time" do
      m.should_receive(:reply).with(TurbotPlugins::MakeMeASandwich::WHAT)
      plugin.make_me_a_sandwich(m)

      m.should_receive(:reply).with(TurbotPlugins::MakeMeASandwich::WHAT)
      plugin.make_me_a_sandwich(m)
    end
  end

  context "user who has sudo asked for a sandwich" do
    before(:each) do
      m.stub(:user => "sudo_guy")
    end

    it "should return 'okay' after sudo-ing for a sandwich" do
      m.should_receive(:reply).with(TurbotPlugins::MakeMeASandwich::BLANK)
      plugin.sudo_make_me_a_sandwich(m)

      m.should_receive(:reply).with(TurbotPlugins::MakeMeASandwich::OKAY)
      plugin.make_me_a_sandwich(m)
    end

    it "should return 'okay' the first time and require a sudo for another sandwich" do
      # Sudo right off the bat
      m.should_receive(:reply).with(TurbotPlugins::MakeMeASandwich::BLANK)
      plugin.sudo_make_me_a_sandwich(m)

      # .. and get a sandwich
      m.should_receive(:reply).with(TurbotPlugins::MakeMeASandwich::OKAY)
      plugin.make_me_a_sandwich(m)

      # .. Have to sudo again
      m.should_receive(:reply).with(TurbotPlugins::MakeMeASandwich::WHAT)
      plugin.make_me_a_sandwich(m)
      m.should_receive(:reply).with(TurbotPlugins::MakeMeASandwich::BLANK)
      plugin.sudo_make_me_a_sandwich(m)

      # .. to get a sandwich
      m.should_receive(:reply).with(TurbotPlugins::MakeMeASandwich::OKAY)
      plugin.make_me_a_sandwich(m)
    end
  end

  context "#help" do
    it "should print the plugins help message." do
      plugin.class.help.matchers.should eql("'.make me a sandwich'")
      plugin.class.help.description.should eql("Request a tasty sandwich")
    end
  end
end

