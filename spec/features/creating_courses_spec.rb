require 'rails_helper'
require 'spec_helper'

describe "Creating courses", type: :feature do
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
    @course_1 = FactoryGirl.create(:course, quarter: @active_q,
                                   instructor: @faculty)
  end

  context "as a guest" do
    it "shouldn't show a link in the navbar or on the quarter's courses page" do

    end

    it "should redirect if we navigate to the 'create course' page" do

    end
  end

  context "as a student" do
    it "shouldn't show a link in the navbar or on the quarter's courses page" do

    end

    it "should redirect if we navigate to the 'create course' page" do

    end
  end

  context "as an instructor" do
    it "shouldn't show a link in the navbar or on the quarter's courses page" do

    end

    it "should redirect if we navigate to the 'create course' page" do

    end
  end

  context "as an admin" do
    it "should show a link in the navbar or on the quarter's courses page" do

    end

    it "should not redirect if we navigate to the 'create course' page" do

    end
  end

end
