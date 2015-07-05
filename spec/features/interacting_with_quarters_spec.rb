require 'rails_helper'
require 'spec_helper'

describe "Interacting with quarters", type: :feature do
  Warden.test_mode!

  subject { page }

  context "that are published" do

    # All users, including guests, can view published quarters.
    it "can be viewed by all users" do

    end

    context "as a student" do

    end

    context "as an instructor" do

    end

    context "as an admin" do

    end
  end

  context "that are unpublished" do

    # Guests and students cannot view unpublished quarters
    # or courses in them.

    # Faculty and admins can view unpublished quarters and their
    # respective courses in them.

    context "as a guest" do
      it "cannot be viewed" do

      end
    end

    context "as a student" do
      it "cannot be viewed" do

      end
    end

    context "as an instructor" do
      it "can be viewed" do

      end
    end

    context "as an admin" do
      it "can be viewed" do

      end
    end

  end
end
