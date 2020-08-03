class ReceiptMailer < ApplicationMailer
    default from: 'naoresponda@bombeiros.pe.gov.br'

    def schedule_email(schedule)
        begin
            attachments.inline["logo_cbmpe.png"] = File.read("#{Rails.root}/app/assets/images/logo_cbmpe.png")
            @schedule = schedule
            mail(to: @schedule.client_email, subject: 'Comprovante do agendamento' )
        rescue => exception
        end
    end

    def schedule_cancel(schedule)
        begin
            attachments.inline["logo_cbmpe.png"] = File.read("#{Rails.root}/app/assets/images/logo_cbmpe.png")
            @schedule = schedule
            mail(to: @schedule.client_email, subject: 'Cancelamento do agendamento' )
        rescue => exception
        end
    end
end