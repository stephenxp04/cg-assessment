class ShortUrl < ApplicationRecord
  belongs_to :url
  has_many :clicks, dependent: :destroy
end
