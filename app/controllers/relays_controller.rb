class RelaysController < ApplicationController
  before_action :set_relay, only: %i[edit update destroy]

  # @route GET /relays (relays)
  def index
    authorize! Relay

    @relays = Relay.all
  end

  # @route GET /relays/new (new_relay)
  def new
    authorize! Relay

    @relay = Relay.new
  end

  # @route POST /relays (relays)
  def create
    authorize! Relay

    @relay = Relay.new(relay_params)

    if @relay.save
      redirect_to relays_path, notice: 'Relay was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # @route GET /relays/:id/edit (edit_relay)
  def edit
    authorize! @relay
  end

  # @route PATCH /relays/:id (relay)
  # @route PUT /relays/:id (relay)
  def update
    authorize! @relay

    if @relay.update(relay_params)
      redirect_to relays_path, notice: 'Relay was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # @route DELETE /relays/:id (relay)
  def destroy
    authorize! @relay

    @relay.destroy

    redirect_to relays_path, notice: 'Relay was successfully destroyed.'
  end

  private

  def set_relay
    @relay = Relay.find(params[:id])
  end

  def relay_params
    params.require(:relay).permit(:url, :description, :enabled)
  end
end
