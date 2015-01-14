class PreferenceCollection
  # As per http://stackoverflow.com/a/17965832/3723769

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :preference_collection

  validate :unique_preferences

  private

  def unique_preferences

  end

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end
end
