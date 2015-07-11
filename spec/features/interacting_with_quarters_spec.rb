require 'rails_helper'
require 'spec_helper'

describe "Interacting with quarters", type: :feature do
  Warden.test_mode!

  subject { page }

  after(:each) { Warden.test_reset! }

  before do
    @year          = FactoryGirl.create(:academic_year, :current)
    @active_q      = FactoryGirl.create(:quarter, :active, published: true,
                                        year: @year.year, season: "winter")
    @inactive_q    = FactoryGirl.create(:quarter, :inactive, published: false,
                                        year: @year.year + 5)
    @admin         = FactoryGirl.create(:admin)
    @faculty       = FactoryGirl.create(:faculty)
    @other_faculty = FactoryGirl.create(:faculty)
    @student       = FactoryGirl.create(:student)
    @other_student = FactoryGirl.create(:student)
    @course_1      = FactoryGirl.create(:course, quarter: @active_q,
                                        instructor: @faculty)

    # Year logic var: will always be @aqy; does not depend on the season.
    @aqy = @active_q.year
    @aqs = @active_q.season
    # Year display var: might be @aqy + 1, depending on the season.
    @aqyd = (["winter", "spring"].include? @aqs) ? (@aqy + 1) : @aqy
  end

  context "that are published" do

    # All users, including guests, can view published quarters.
    context "on their pages" do
      it "can be viewed by all users" do
        visit root_path

        expect(current_path).to eq(courses_path(season: @aqs,
                                                year: @aqyd))
        expect(page).to have_content(@aqs.capitalize)
        expect(page).to have_content(@aqyd)

        visit courses_path(season: @aqs, year: @aqyd)
        expect(current_path).to eq(courses_path(season: @aqs,
                                                year: @aqyd))
        expect(page).to have_content(@aqs.capitalize)
        expect(page).to have_content(@aqyd)
      end
    end

    context "in the navbar" do
      context "if in the current academic year" do

        context "as any user" do
          it "should have the courses link" do
            visit root_path

            expect(page).to have_selector('.nav') do |nav|
              expect(nav).to contain(/#dropdown-#{@aqy}-#{@aqs}/) # Will not be `year + 1`.
              expect(nav).to have_link("Courses")
            end
          end
        end

        context "as a student" do
          before { ldap_sign_in(@student) }

          context "before the bidding deadline" do
            before do
              @active_q.update_column(:student_bidding_deadline,
                                      DateTime.now + 3.days)
              visit q_path(@course_1)
            end

            it "should have the bidding link" do
              expect(current_path).to eq(q_path(@course_1))
              expect(page).to have_content("bid")
              expect(page).to have_link("bid")
              # FIXME:
              # There should be text with a link that specifies that students
              # can bid for and rank this course on their "my requests" page.
            end

            it "should succeed if the user bids for / ranks the course" do
              # Bids can't be made on the course page -- they're made on the
              # "my requests" page.
              click_link("bid")
              expect(current_path).to eq(my_requests_path(season: @aqs,
                                                          year: @aqd))
              # Expect to see the dropdown; update it; hit the
              # "save preferences" button.
              # [NOTE: This isn't critical. We won't test it for now.]
            end
          end

          context "after the bidding deadline" do
            before do
              @active_q.update_column(:student_bidding_deadline,
                                      DateTime.now - 3.days)
              visit q_path(@course_1)
            end

            it "should not have the bidding link" do
              expect(current_path).to eq(q_path(@course_1))
              expect(page).not_to have_content("Bid")
              expect(page).not_to have_link("Bid")
            end

            it "should redirect if the user tries to submit a bid" do
              # FIXME: Submit a POST request
              # [NOTE: This isn't critical. We won't test it for now.]
            end
          end

        end

        context "as an admin" do
          before { ldap_sign_in(@admin) }

          it "should have courses, drafts, and submission links" do
            visit root_path

            expect(page).to have_selector('.nav') do |nav|
              expect(nav).to contain(/#dropdown-#{@aqy}-#{@aqs}/)
              expect(nav).to have_link("Courses")
              expect(nav).to have_link("Course drafts")
              expect(nav).to have_link("Courses")
            end
          end

          # FIXME: Why does the course submission deadline exist?
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

      context "if not in the current academic year" do
        context "but in the next academic year" do
          before do
            @next_year   = FactoryGirl.create(:academic_year,
                                              year: @year.year + 1)
            @q_next_year = FactoryGirl.create(:quarter, :inactive,
                                              published: true,
                                              year: @next_year.year)
          end

          it "should display a year tab on the right side of the navbar" do
            visit root_path

            # Visible to all users
            expect(page).to have_selector('.nav') do |nav|
              expect(nav).to contain(/#next_academic_year/)
              expect(nav).to have_link("Next academic year")
            end
          end

          it "should let users navigate to a page with published quarters " \
             "in the next academic year" do
            visit root_path

            # Visible to all users
            expect(page).to have_selector('.nav') do |nav|
              expect(nav).to contain(/#next_academic_year/)
              click_link("Next academic year")
              expect(current_path).to eq(academic_year_path(year: @year_goes_here)) # FIXME
            end
          end
        end
      end
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
