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
    @course_1 = FactoryGirl.create(:course, quarter: @active_q,
                                   instructor: @faculty)
  end

  context "that are published" do

    # All users, including guests, can view published quarters.
    context "on their pages" do
      it "can be viewed by all users" do
        visit root_path
        expect(page).to have_content(@course_1.title)
      end
    end

    context "in the navbar" do
      context "if in the current academic year" do

        context "as any user" do
          it "should have the courses link" do

          end
        end

        context "as a student" do
          context "before the bidding deadline" do
            it "should have the bidding link" do

            end

            it "should succeed if the user tries to submit a bid" do

            end
          end

          context "after the bidding deadline" do
            it "should not have the bidding link" do

            end

            it "should redirect if the user tries to submit a bid" do
              # Submit a POST request
            end
          end

        end

        context "as an admin" do
          it "should have courses, drafts, and submission links" do

          end

          # TODO: Why does the course submission deadline exist?
          # Instructors can't create courses, and admins can change the
          # deadline whenever they want.

          # context "before the course submission deadline" do
          #   it "should have a course submission link" do

          #   end
          # end

          # context "after the course submission deadline" do
          #   it "should not have a course submission link" do

          #   end
          # end

        end
      end

      # TODO: This will be changed.

      # context "if not in the current academic year" do
      #   it "cannot be viewed by any users" do

      #   end

      #   # TODO: But users should still be able to interact with the quarter;
      #   # e.g., admins should be able to create courses, instructors should be
      #   # able to edit those courses, and students should be able to bid for
      #   # them.
      #   # If it's currently spring of 20xx, users should be able to interact
      #   # with courses in summer of 20xx.
      #   # ...
      # end
    end
  end

  context "that are unpublished" do

    # Guests and students cannot view unpublished quarters
    # or courses in them.

    # Faculty and admins can view unpublished quarters and their
    # respective courses in them.

    context "as a guest" do
      it "cannot be viewed" do
        visit courses_path(season: @inactive_q.season, year: @inactive_q.year)
        expect(current_path).to eq(root_path)
        expect(page).to have_content("Access denied")
        expect(page).to have_selector("div.alert.alert-danger")
      end
    end

    context "as a student" do
      it "cannot be viewed" do
        visit courses_path(season: @inactive_q.season, year: @inactive_q.year)
        expect(current_path).to eq(root_path)
        expect(page).to have_content("Access denied")
        expect(page).to have_selector("div.alert.alert-danger")
      end
    end

    context "as an instructor" do
      it "can be viewed" do
        visit courses_path(season: @inactive_q.season, year: @inactive_q.year)
        expect(current_path).to eq(courses_path(season: @inactive_q.season,
                                                year: @inactive_q.year))
        expect(page).not_to have_content("Access denied")
        expect(page).not_to have_selector("div.alert.alert-danger")
      end
    end

    context "as an admin" do
      it "can be viewed" do
        visit courses_path(season: @inactive_q.season, year: @inactive_q.year)
        expect(current_path).to eq(courses_path(season: @inactive_q.season,
                                                year: @inactive_q.year))
        expect(page).not_to have_content("Access denied")
        expect(page).not_to have_selector("div.alert.alert-danger")
      end
    end

  end
end
