require 'rails_helper'
require 'spec_helper'

describe "Viewing the navbar", type: :feature do
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

  # TODO: add specs for what links different types of users should and should
  # not see in the navbar.
end
