class NovoSga::Service < NovoSga::NovoSga
    self.table_name ='public.servicos'

    def get_initials(service_point_id)
        NovoSga::ServiceServicePoint.where(unidade_id: service_point_id).where(servico_id: id).first.sigla
    end

    def get_counter(service_point_id)
        NovoSga::AttendanceCounter.where(unidade_id: service_point_id).where(servico_id: id).first.numero
    end

    def count_update(service_point_id)
        NovoSga::AttendanceCounter.increment(service_point_id, id, get_counter(service_point_id))
    end

end
