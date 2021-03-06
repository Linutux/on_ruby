class Location < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  extend ApiHandling
  expose_api :id, :name, :url, :city, :street, :house_number, :zip

  geocoded_by :full_address, latitude: :lat, longitude: :long
  after_validation :geocode unless Rails.env.test? # REM (ps) no geocoder for tests

  has_many :events
  has_many :jobs

  validates :name, :url, :city, :street, :house_number, :zip, presence: true

  default_scope -> { where(label: Whitelabel[:label_id]) }

  def full_address
    "#{address}, #{I18n.t('countries.DE')}"
  end

  def address
    "#{street} #{house_number}, #{zip} #{city}"
  end

  def nice_url
    URI.parse(url).host
  end
end
