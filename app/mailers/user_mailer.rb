class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("account_active.account_activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("password_reset.pwd_reset")
  end
end
