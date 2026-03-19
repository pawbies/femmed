class DoseReminderJob < ApplicationJob
  queue_as :default

  REMINDER_WINDOW = 15.minutes
  TAKEN_WINDOW    = 1.hour

  def perform
    now        = Time.now
    window_end = now + REMINDER_WINDOW

    User.joins(:push_subscriptions).distinct.each do |user|
      user.prescriptions.where(active: true).each do |prescription|
        puts "Going for #{prescription.full_name}"
        next unless prescription.routine.present?

        puts "Passwd check"

        prescription.routine.occurrences_between(now, window_end).each do |occurrence|
          puts "found occurance"
          next if already_taken?(prescription, occurrence)
          puts "passed second check"

          send_reminder(user, prescription, occurrence)
        end
      end
    end
  end

  private

  def already_taken?(prescription, occurrence)
    prescription.doses.where(
      taken_at: (occurrence.utc - TAKEN_WINDOW)..(occurrence.utc + REMINDER_WINDOW)
    ).exists?
  end

  def send_reminder(user, prescription, occurrence)
    name = prescription.full_name.presence || "your medication"
    time = occurrence.strftime("%H:%M")

    PushNotificationService.new(
      user:  user,
      title: "Dose reminder",
      body:  "#{name} due at #{time}",
      url:   "/prescriptions/#{prescription.id}/doses/new"
    ).call
  end
end
