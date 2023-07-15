class StoriesController < ApplicationController
  # @route POST /stories (stories)
  def create
    if Story.current?
      # Find last non published chapter of current story
      @story = Story.currents.last
      @chapter = @story.chapters.where(published_at: nil).first
      @last_published = @chapter.last_published

      @command = "noscl publish --reference #{@last_published.event_identifier} \"#{@chapter.title}\n\n#{@chapter.content}\""
    else
      # Generate a brand new story
      json = ChatgptService.call(prompt)

      ApplicationRecord.transaction do
        @story = Story.create!(
          title: title,
          adventure_ended_at: nil,
          raw_response_body: json
        )

        json.each do |chapter|
          @story.chapters.create!(
            title: chapter['title'],
            content: chapter['content']
          )
        end
      end

      @chapter = @story.chapters.first

      @command = "noscl publish \"#{@story.title}\n\n #{@chapter.title}\n\n#{@chapter.content}\""
    end

    IO.popen(@command) do |pipe|
      @output = pipe.readlines
    end

    event_id = @output.last.split[1]

    @chapter.update!(
      event_identifier: event_id,
      published_at: Time.current
    )

    @story.ended! if @chapter.last_published?

    redirect_to root_path, notice: "L'aventure a bien été publiée sur Nostr (nostr event: #{@chapter.event_identifier})"
  rescue OpenaiChatgpt::Error, StandardError => e
    redirect_to root_path, alert: e.message
  end

  private

  def prompt
    'Invente une aventure médiévale'
  end

  def title
    'Aventure médiévale'
  end
end
