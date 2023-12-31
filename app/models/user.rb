class User < ApplicationRecord
  EMAIL_REGEX = /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/

  enum :role, { standard: 0, admin: 1, super_admin: 2 }, validate: true

  belongs_to :company, counter_cache: true

  has_one_attached :avatar

  authenticates_with_sorcery!

  encrypts :email, deterministic: true, downcase: true

  validates :email, presence: true,
                    format: { with: EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 },
                       presence: true,
                       confirmation: true,
                       if: :validate_password?
  validates :password_confirmation, presence: true, if: :validate_password?

  private

  def validate_password?
    new_record? || changes[:crypted_password] || reset_password_token_changed?
  end
end

# == Schema Information
#
# Table name: users
#
#  id                                  :uuid             not null, primary key
#  email                               :string           not null
#  crypted_password                    :string
#  salt                                :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  remember_me_token                   :string
#  remember_me_token_expires_at        :datetime
#  reset_password_token                :string
#  reset_password_token_expires_at     :datetime
#  reset_password_email_sent_at        :datetime
#  access_count_to_reset_password_page :integer          default(0)
#  role                                :integer          default("standard"), not null
#  company_id                          :uuid
#
# Indexes
#
#  index_users_on_company_id            (company_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_remember_me_token     (remember_me_token)
#  index_users_on_reset_password_token  (reset_password_token)
#
