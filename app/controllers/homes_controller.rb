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

    begin
      if modal_chapter?
        @chapter_popup = Chapter.find_by(id: chapter_id, story_id: story_id)
      elsif modal_story?
        @story_popup = Story.find_by(id: story_id)
      end
    rescue URI::InvalidURIError
      @chapter_popup = nil
      @story_popup = nil
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

  def story_id
    decoded_modal_params[:story_id]
  end

  def chapter_id
    decoded_modal_params[:chapter_id]
  end

  def modal_story?
    modal? && story_id && !chapter_id
  end

  def modal_chapter?
    modal? && story_id && chapter_id
  end
end
