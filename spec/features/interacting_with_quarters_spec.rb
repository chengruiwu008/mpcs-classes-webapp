require 'rails_helper'
require 'spec_helper'

describe "Interacting with quarters", type: :feature do
  Warden.test_mode!

  subject { page }

  after(:each) { Warden.test_reset! }

  before do
    @year          = FactoryGirl.create(:academic_year, :current)
    # FIXME: need to specify deadlines for these quarters?
    @active_q      = FactoryGirl.create(:quarter, :active, published: true,
                                        year: @year.year, season: "winter")
    @inactive_q    = FactoryGirl.create(:quarter, :inactive, published: false,
                                        year: @year.year + 5)
    @admin         = FactoryGirl.create(:admin)
    @faculty       = FactoryGirl.create(:faculty)
    @other_faculty = FactoryGirl.create(:faculty)
    @student       = FactoryGirl.create(:student)
    @other_student = FactoryGirl.create(:student)
  end

  context "that are published" do

    # All users, including guests, can view published quarters.
    it "can be viewed by all users" do

    end

    context "as a student" do
      before { ldap_sign_in(@student) }
    end

    context "as an instructor" do
      before { ldap_sign_in(@faculty) }
    end

    context "as an admin" do
      before { ldap_sign_in(@admin) }
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
