class OfficeUsersBalanceUpdater < ApplicationService
  def initialize(office_id, dates_that_change_balance)
    @office = Office.find_by(id: office_id)
    @non_working_dates = dates_that_change_balance[:non_working_dates]
    @working_dates = dates_that_change_balance[:working_dates]
  end

  def call
    @office&.users&.active&.each do |user|
      # increase_balance(user) if @non_working_dates.present?
      # decrease_balance(user) if @working_dates.present?
      user.increase_vacation_balance(change_balance(user, @non_working_dates)) if @non_working_dates.present?
      user.decrease_vacation_balance(change_balance(user, @working_dates)) if @working_dates.present?
    end
  end

  private

  # def increase_balance(user)
  #   vacations = user.vacations&.not_declined&.on_dates(@non_working_dates.first, @non_working_dates.last)

  #   return if vacations.blank?

  #   non_working_dates_count = vacations.inject(0) do |sum, v|
  #     sum + (v.start_date.to_date..v.finish_date.to_date).count { |date| @non_working_dates.include?(date.to_s) }
  #   end

  #   user.increase_vacation_balance(non_working_dates_count)
  # end

  # def decrease_balance(user)
  #   vacations = user.vacations&.not_declined&.on_dates(@working_dates.first, @working_dates.last)

  #   return if vacations.blank?

  #   working_dates_count = vacations.inject(0) do |sum, v|
  #     sum + (v.start_date.to_date..v.finish_date.to_date).count { |date| @working_dates.include?(date.to_s) }
  #   end

  #   user.decrease_vacation_balance(working_dates_count)
  # end

  def change_balance(user, dates)
    vacations = user.vacations&.not_declined&.on_dates(dates.first, dates.last)

    return if vacations.blank?

    dates_count = vacations.inject(0) do |sum, v|
      sum + (v.start_date.to_date..v.finish_date.to_date).count { |date| dates.include?(date.to_s) }
    end
    dates_count
  end

end
