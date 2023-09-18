module Prompts
  class SystemPrompt < ApplicationService
    private

    def language
      I18nData.languages(:en)[story.nostr_user.language.upcase]
    end

    def options
      @options ||= story.options
    end

    def minimum_chapters_count
      options.minimum_chapters_count
    end

    def maximum_chapters_count
      options.maximum_chapters_count
    end

    def default_system_prompt_with_replaced_variables
      default_system_prompt
        .gsub('{{language}}', language)
        .gsub('{{minimum_chapters_count}}', minimum_chapters_count.to_s)
        .gsub('{{maximum_chapters_count}}', maximum_chapters_count.to_s)
    end

    def narrator_prompt
      <<~STRING
        Integrate the following narrator style into the adventure:

        "#{story.narrator_prompt.body}".
      STRING
    end

    def narrator_negative_prompt
      return '' if story.narrator_prompt.negative_body.blank?

      <<~STRING
        Ensure the following style won't be part of the adventure:

        "#{story.narrator_prompt.negative_body}".
      STRING
    end

    def atmosphere_prompt
      <<~STRING
        Integrate the following atmosphere style into the adventure:

        "#{story.atmosphere_prompt.body}".
      STRING
    end

    def atmosphere_negative_prompt
      return '' if story.atmosphere_prompt.negative_body.blank?

      <<~STRING
        Ensure the following atmosphere won't be part of the adventure:

        "#{story.atmosphere_prompt.negative_body}".
      STRING
    end

    def characters_prompt
      return '' unless story.characters.any?

      <<~STRING
        Integrate the following characters into the adventure:

        #{story.characters.map { |character| "\"#{character.full_name}: #{character.biography}\"" }.join(', ')}.
      STRING
    end

    def places_prompt
      return '' unless story.places.any?

      <<~STRING
        Integrate the following places into the adventure:

        #{story.places.map { |place| "\"#{place.name}: #{place.description}\"" }.join(', ')}.
      STRING
    end

    def response_format
      <<~STRING
        Provide a RFC 8259 compliant JSON response following this format without deviation: #{json_format.to_json}
      STRING
    end
  end
end
