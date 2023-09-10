class HomesController < ApplicationController
  helper_method :display_ended?

  # @route GET / (root)
  def show
    if display_ended?
      @stories = Story.ended
    else
      @stories = Story.currents

      @publishable_stories = Story.publishable

      @active_stories = {}
      NostrUser.pluck(:language).each do |language|
        @active_stories[language] = Story.publishable(language: language).first
      end

    end

    @chapter_popup = begin
      if modal? && valid_modal_params?
        Chapter.find_by(
          id: decoded_modal_params[:chapter_id],
          story_id: decoded_modal_params[:story_id]
        )
      end
    rescue URI::InvalidURIError
      nil
    end

    @pagy, @stories = pagy(
      @stories
        .with_attached_cover
        .includes(nostr_user: :picture_attachment)
        .order(updated_at: :desc),
      items: 6,
      params: ->(params) { params.except('modal') }
    )
  end

  private

  def display_ended?
    params[:display_ended].to_bool
  end

  def modal?
    params[:modal].present?
  end

  def decoded_modal_params
    @decoded_modal_params ||= URI.decode_www_form(
      URI.parse(Base64.decode64(params[:modal])).query
    ).to_h.with_indifferent_access
  end

  def valid_modal_params?
    decoded_modal_params[:story_id].present? &&
      decoded_modal_params[:chapter_id].present?
  end
end
