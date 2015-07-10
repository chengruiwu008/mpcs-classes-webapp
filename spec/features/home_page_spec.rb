require 'rails_helper'
require 'spec_helper'

describe "Viewing the homepage", type: :feature do
  Warden.test_mode!

  subject { page }

  after(:each) { Warden.test_reset! }

  context "when no quarters exist" do
    it "does not produce an error" do
      visit root_path
      expect(page).to have_content("MPCS")
      # FIXME: This actually produces an error, so fix it!
    end
  end

  context "when quarters exist" do
    before { @year = FactoryGirl.create(:academic_year, :current) }

    context "and there is an active quarter" do
      before do
        # TODO: specify deadlines for quarter?
        @active_q = FactoryGirl.create(:quarter, :active, published: true,
                                       year: @year.year, season: "winter")
      end

      context "that has courses" do
        before do
          @instructor = FactoryGirl.create(:faculty)
          @course_1 = FactoryGirl.create(:course, quarter: @active_q,
                                        instructor: @instructor)
        end

        it "should display its published courses" do
          visit root_path
          expect(page).to have_content(@course_1.title)
        end
      end

      context "that has no courses" do
        it "should display a message" do
          visit root_path
          expect(page).to have_content("There are no courses in this quarter")
        end
      end
    end

    context "when there is no active quarter" do
      before do
        # TODO: specify deadline for quarter?
        @inactive_q = FactoryGirl.create(:quarter, :inactive, published: true,
                                       year: @year.year)
      end

      context "and there is an upcoming quarter" do
        before do
          @upcoming_q = FactoryGirl.create(:quarter, :upcoming, published: true,
                                           year: @year.year)
        end

        context "with courses" do
          before do
            @instructor = FactoryGirl.create(:faculty)
            @course_1 = FactoryGirl.create(:course, quarter: @upcoming_q,
                                           instructor: @instructor)
          end

          it "should display its courses" do
            visit root_path
            expect(page).to have_content(@course_1.title)
          end
        end

        context "without courses" do
          it "should display a message" do
            # FIXME: should it?
            visit root_path
            expect(page).to have_content("There are no courses to show")
          end
        end
      end

      context "and there are no upcoming quarters" do
        it "should display a message" do
          visit root_path
          expect(page).to have_content("There are no courses to show")
        end
      end
    end
  end
end
