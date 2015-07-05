require 'rails_helper'
require 'spec_helper'

describe "Interacting with courses", type: :feature do
  Warden.test_mode!

  subject { page }

  after(:each) { Warden.test_reset! }

  context "that have been published" do
    context "as a guest" do

    end

    context "as a student" do

    end

    context "as an instructor" do

    end

    context "as an admin" do

    end
  end

  context "that have not been published" do
    context "as a guest" do
      it "should not be viewable" do

      end

      it "should not be able to be bid for" do

      end
    end

    context "as a student" do
      it "should not be viewable" do

      end

      it "should not be able to be bid for" do

      end
    end


    context "as the instructor teaching it" do
      it "should be viewable" do

      end

      it "should be editable" do

      end
    end

    context "as an unrelated instructor" do
      it "should not be viewable" do

      end

      it "should not be editable" do

      end
    end

    context "as an admin" do
      it "should be viewable" do

      end

      it "should be editable" do

      end
    end
  end

  # Admins should also be able to create courses in any quarter, published
  # or unpublished, but they should not be able to publish courses in
  # unpublished quarters.

  # Instructors should not be able to create OR PUBLISH courses. They should
  # be able to edit any of their courses, and there are three cases:

  # 1. published course in published quarter;
  # 2. unpublished course in published quarter;
  # 3. unpublished course in unpublished quarter.
  # (Courses cannot be published in unpublished quarters.)


end
