require 'spec_helper'

require_relative '../../plugin/pollster_cinch_plugin.rb'

describe TurbotPlugins::Pollster do

  context "#set_poll" do
    context "If passed a string from a valid user." do
      let(:m) { double(:user => double(:nick => "rondale_sc"))  }
      let(:question) { "This is a question" }

      it "should set the question for a poll" do
        m.should_receive(:reply).with("Your poll was successfully created!")

        plugin = TurbotPlugins::Pollster.new(double.as_null_object)
        plugin.set_poll(m,question)
      end

      it "save the question to an accessor" do
        m.stub(:reply)

        plugin = TurbotPlugins::Pollster.new(double.as_null_object)
        plugin.set_poll(m, question)

        expect(plugin.question).to eq(question)
      end

    end

    context "If passed a string from invalid user." do
      let(:m) { double(:user => double(:nick => "not_valid_nick"))  }
      it "should return false" do
        m.should_receive(:reply).with("You do not have the correct permissions")

        plugin = TurbotPlugins::Pollster.new(double.as_null_object)
        plugin.set_poll(m, "This is a question")
      end
    end
  end
end
