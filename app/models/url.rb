class Url < ApplicationRecord
  belongs_to :user
  has_many :short_urls, dependent: :destroy
end
