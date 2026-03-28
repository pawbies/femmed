class Transfer::ExportsController < ApplicationController
  def new
  end

  def create
    unless params.dig(:data, :prescriptions) == "1" || params.dig(:data, :profile) == "1"
      redirect_to new_export_path, notice: t(".pick_at_least_one")
      return
    end

    csv = CSV.generate(headers: true) do |csv|
      if params.dig(:data, :prescriptions) == "1"
        @prescriptions = Current.user.prescriptions.includes(
          { medication_version: { medication: :form } },
          :doses,
          :packs
        )


        csv << [
          "Prescription",
          "Planned Dose",
          "Active/Inactive",
          "Created at",
          "History"
        ]
        @prescriptions.each do |prescription|
          records = (prescription.doses + prescription.packs).sort_by do |record|
            case record
            when Prescription::Dose then record.taken_at
            when Prescription::Pack then record.acquired_at
            end
          end

          csv << [
            prescription.full_name,
            "#{format("%g", prescription.amount)} #{prescription.form.name.pluralize(prescription.amount)}",
            prescription.active? ? "Active" : "Inactive",
            prescription.created_at.iso8601
          ]

          records.each do |record|
            csv << [
              "",
              "",
              "",
              "",
              case record
              when Prescription::Dose then
                "#{format("%g", record.amount_taken)} #{prescription.form.name.pluralize(record.amount_taken)} Dose at #{record.taken_at.strftime("%B %e, %Y %H:%M")}"
              when Prescription::Pack then
                "#{record.amount} #{prescription.form.name.pluralize(record.amount)} Pack at #{record.acquired_at.strftime("%B %e, %Y")}"
              end
            ]
          end
        end
        2.times do csv << [] end
      end

      if params.dig(:data, :profile) == "1"
        user = Current.user
        csv << [ "Email address", "Username", "Language", "Created at" ]
        csv << [ user.email_address, user.username, user.language, user.created_at.strftime("%B %e, %Y %H:%M") ]
        2.times do csv << [] end
      end
    end

    send_data csv, filename: "femmed-export-#{Current.user.username}-#{Date.today}.csv", type: "text/csv"
  end
end
