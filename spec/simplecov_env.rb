require 'simplecov'

module SimpleCovEnv
  module_function

  def start!
    return unless ENV['COVERAGE']

    SimpleCov.start :rails do
      configure_formatter
      configure_profile
    end
  end

  def configure_formatter
    formatter SimpleCov::Formatter::HTMLFormatter
  end

  def configure_profile
    add_filter '/app/channels/'

    add_group 'Controllers', 'app/controllers'
    add_group 'Models', 'app/models'
    add_group 'Helpers', 'app/helpers'
    add_group 'Services', 'app/services'
    add_group 'Mailers', 'app/mailers'
    add_group 'Jobs', 'app/jobs'
    add_group 'Policies', 'app/policies'
    add_group 'Exceptions', 'app/exceptions'
    add_group 'Libraries', 'lib'
  end
end
