class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.human_enum_name(enum_name, enum_value, locale: I18n.locale)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}", locale: locale)
  end

  def self.broadcast_flash(type, message, disappear: true)
    Turbo::StreamsChannel.broadcast_prepend_to(
      :flashes,
      target: 'flashes',
      partial: 'flash',
      locals: {
        flash_type: type.to_s,
        message: message,
        disappear: disappear
      }
    )
  end
end
