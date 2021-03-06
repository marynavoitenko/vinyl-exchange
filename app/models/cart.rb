class Cart < ApplicationRecord
  has_many :line_items
  has_many :vinyls, through: :line_items
  belongs_to :user

  def add_item(vinyl_id)
    line_item = self.line_items.find_by(vinyl_id: vinyl_id)

    if line_item
      line_item.quantity += 1
    else
      line_item = self.line_items.build(vinyl_id: vinyl_id)
    end

    self.update_inventory(vinyl_id) if line_item.vinyl.in_stock
    line_item.save
  end

  def update_inventory(vinyl_id, qty=1)
    vinyl = Vinyl.find(vinyl_id)
    vinyl.inventory -= qty if qty <= vinyl.inventory
    vinyl.for_sale = false if vinyl.inventory < 1
    vinyl.save
  end

  def total
    total = 0
    self.line_items.each do |line_item|
      vinyl = Vinyl.find(line_item.vinyl_id)
      total += (vinyl.price * line_item.quantity)
    end
    total
  end
end
