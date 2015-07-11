require 'rails_helper'
require 'spec_helper'

describe "Interacting with courses", type: :feature do
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

  # context "in an unpublished quarter" do
  #   # (Not essential)
  # end

  context "in a published quarter" do
    context "that have been published" do
      context "as a guest" do
        it "should have a link on the quarter's page" do
          # We should see a link to them in the courses table, both by navigating
          # to the course page and by visiting the home page*, and we should be
          # able to visit the course page and view its information.

          # (We should be able to click the course link in the table.)

          # * TODO: write a separate spec to check that the active quarter's courses
          # are shown on the homepage, if it's published. If it's not published or
          # it has no courses, show the next immediate quarter's courses (if it
          # exists).
        end

        it "should not have a link to submit a bid" do
        end

        it "should not have a link to edit the course info" do
        end

        it "should redirect if we navigate to the 'bid' path" do
        end

        it "should redirect if we navigate to the 'edit course' path" do
        end

      end

      context "as a student" do

        it "should have a link on the quarter's page" do
          # We should see a link to them in the courses table, both by navigating
          # navigating to the course page and by visiting the home page, and we
          # should be able to visit the course page and view its information.
        end

        context "before the bidding deadline" do
          it "should have a link to submit a bid" do
          end

          it "should not redirect if we navigate to the 'edit course' path" do
          end
        end

        context "after the bidding deadline" do
          it "should not have a link to submit a bid" do
          end

          it "should redirect if we navigate to the 'edit course' path" do
          end
        end

        it "should redirect if we navigate to the 'bid' path" do
        end

        it "should redirect if we navigate to the 'edit course' path" do
        end

      end

      context "as the instructor teaching the course" do
        it "should have a link on the quarter's page" do
          # We should see a link to them in the courses table, both by navigating
          # navigating to the course page and by visiting the home page, and we
          # should be able to visit the course page and view its information.
        end

        it "should not have a link to submit a bid" do
        end

        it "should redirect if we navigate to the 'bid' path" do
        end

        it "should have a link to edit the course info" do
        end

        it "should not redirect if we navigate to the 'edit course' path" do
        end

      end

      context "as an instructor not teaching the course" do
        it "should have a link on the quarter's page" do
          # We should see a link to them in the courses table, both by navigating
          # navigating to the course page and by visiting the home page, and we
          # should be able to visit the course page and view its information.
        end

        it "should not have a link to submit a bid" do
        end

        it "should redirect if we navigate to the 'bid' path" do
        end

        it "should not have a link to edit the course info" do
        end

        it "should redirect if we navigate to the 'edit course' path" do
        end

      end

      context "as an admin" do
        it "should have a link on the quarter's page" do
          # We should see a link to them in the courses table, both by navigating
          # navigating to the course page and by visiting the home page, and we
          # should be able to visit the course page and view its information.
        end

        it "should not have a link to submit a bid" do
        end

        it "should have a link to edit the course info" do
        end

        it "should redirect if we navigate to the 'bid' path" do
        end

        it "should not redirect if we navigate to the 'edit course' path" do
        end

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
