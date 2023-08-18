# Base class for application policies
class ApplicationPolicy < ActionPolicy::Base
  # Configure additional authorization contexts here
  # (`user` is added by default).
  #
  #   authorize :account, optional: true
  #
  # Read more about authorization context: https://actionpolicy.evilmartians.io/#/authorization_context

  # Define shared methods useful for most policies.
  # For example:
  #
  #  def owner?
  #    record.user_id == user.id
  #  end

  private

  def allow_super_admins
    deny! unless user.super_admin?
  end

  def allow_admins
    deny! unless admin_up?
  end

  def admin_up?
    user.admin? || user.super_admin?
  end
end
