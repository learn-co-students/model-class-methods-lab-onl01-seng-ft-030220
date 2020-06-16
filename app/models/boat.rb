class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  def self.first_five
    all.first(5)
  end

  def self.dinghy
    all.where("length < 20")
  end

  def self.ship
    all.where("length > 20")
  end

  def self.last_three_alphabetically
    all.order(name: :asc).reverse_order.limit(3)
  end

  def self.without_a_captain
    all.where(captain_id: nil)
  end

  def self.sailboats
    all.includes(:classifications).where(classifications: { name: 'Sailboat' })
  end

  def self.with_three_classifications
    all.joins(:classifications).group("boats.id").having("COUNT(*) = 3").select("boats.*")
  end

  def self.non_sailboats
    all.where("id NOT IN (?)", self.sailboats.pluck(:id))
  end

  def self.longest
    all.order("length DESC").first
  end
end