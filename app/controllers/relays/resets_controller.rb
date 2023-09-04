module Relays
  class ResetsController < ApplicationController
    # @route POST /relays/resets (relays_resets)
    def create
      authorize! Relay, with: ResetListPolicy

      Relay.reset!

      redirect_to relays_path, notice: 'Les relais ont été réinitialisés'
    end
  end
end
