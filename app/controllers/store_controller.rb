class StoreController < ApplicationController
  def index
    @vinyls = Vinyl.for_sale_exclude_current_user(current_user)
  end
end
