class NovoSga::Attendance < NovoSga::NovoSga
    self.table_name ='public.atendimentos'
    STATUS = {emit: 'emitida', cancel: 'cancelada'}.freeze

    def self.queue_today
        begin
            schedules_today = ::Schedule.get_today

            schedules_today.each do |schedule_today|
                if where({senha_numero: schedule_today.sga_token_number, senha_sigla: schedule_today.sga_token_initials, dt_cheg: schedule_today.get_datetime}).empty?
                    client = NovoSga::Client.create(nome: schedule_today.client_name, email: schedule_today.client_email, documento: '')
                    NovoSga::Attendance.create(
                        cliente_id: client.id,
                        unidade_id: schedule_today.get_novo_sga_service_point_id,
                        servico_id: schedule_today.get_novo_sga_service_id,
                        dt_cheg: schedule_today.get_datetime,
                        prioridade_id: NovoSga::Priority.get_normal_priority_id, #pegar prioridade normal no banco do sga
                        usuario_tri_id: NovoSga::User.get_admin_user_id, #pegar id do usuario administrador no banco do sga
                        status: schedule_today.sga_status,
                        senha_numero: schedule_today.sga_token_number,
                        senha_sigla: schedule_today.sga_token_initials
                    )
                    schedule_today.service.novo_sga_service.count_update(schedule_today.get_novo_sga_service_point_id)
                end
            end
            'Fila de atendimentos agendados formada no SGA.'
        rescue
            'Algum erro aconteceu. Contate o CTIC.'
        end
    end
end
