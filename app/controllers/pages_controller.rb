class PagesController < ApplicationController
  include BlockchainHelper

  def home
  end

  def swap
    block_number = 26444465
    @swap_events = get_swap_events(block_number)
  end

  def mana
    @mana_info = get_mana_info
  end
end
