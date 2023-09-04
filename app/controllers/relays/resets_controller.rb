module Relays
  class ResetsController < ApplicationController
    # @route POST /relays/resets (relays_resets)
    def create
      authorize! Relay, with: ResetListPolicy

      Relay.reset!

      redirect_to relays_path, notice: 'Les relays ont été réinitialisés'
    end
  end
end
