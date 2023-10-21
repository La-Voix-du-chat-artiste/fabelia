module SettingsHelper
  def highlight_code(json)
    json = json.gsub(',"', ",\n\"")
               .gsub('{', "{\n")
               .gsub('}', "\n}")
               .gsub('":', '": ')
               .gsub('true}', "true\n}")
               .gsub('false}', "false\n}")

    Pygments.highlight(json, lexer: :json)
  end

  def settings_theme_select_options
    Option::THEMES.map do |theme|
      [t(theme), theme]
    end
  end

  def dark_theme?
    options.theme == 'dark'
  end

  def light_theme?
    !dark_theme?
  end
end
