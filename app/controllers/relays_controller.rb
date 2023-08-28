class RelaysController < ApplicationController
  before_action :set_relay, only: %i[edit update destroy]

  # @route GET /relays (relays)
  def index
    authorize! Relay

    @relays = Relay.all.by_position
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

    respond_to do |format|
      if @relay.save
        format.html { redirect_to relays_path, notice: 'Relay was successfully created.', status: :see_other }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
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

    respond_to do |format|
      if @relay.update(relay_params)
        format.html { redirect_to relays_path, notice: 'Relay was successfully updated.', status: :see_other }
        format.turbo_stream if @relay.position_previously_changed?
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /relays/:id (relay)
  def destroy
    authorize! @relay

    @relay.destroy

    respond_to do |format|
      notice = 'Relay was successfully destroyed.'

      format.html { redirect_to relays_path, notice: notice }
      format.turbo_stream { flash.now[:notice] = notice }
    end
  end

  private

  def set_relay
    @relay = Relay.find(params[:id])
  end

  def relay_params
    params.require(:relay).permit(:url, :description, :enabled, :position)
  end
end
