require 'rails_helper'
require 'spec_helper'

describe "Viewing the homepage", type: :feature do
  Warden.test_mode!

  subject { page }

  after(:each) { Warden.test_reset! }

  context "when no quarters exist" do
    it "does not produce an error" do

    end
  end

  context "when quarters exist" do
    context "and there is an active quarter" do
      context "that has courses" do
        it "should display its published courses" do

        end
      end

      context "that has no courses" do
        it "should display a message" do

        end
      end
    end

    context "when there is no active quarter" do
      context "and there is an upcoming quarter" do
        context "with courses" do
          it "should display its courses" do

          end
        end

        context "without courses" do
          it "should display a message" do
            # FIXME: should it?
          end
        end
      end

      context "and there are no upcoming quarters" do
        it "should display a message" do

        end
      end
    end
  end

end
