class NovoSga::AttendanceCounter < NovoSga::NovoSga
    self.table_name ='public.contador'

    def self.increment(service_point_id, service_id, numero)
        where(unidade_id: service_point_id).where(servico_id: service_id).update_all(numero: numero + 1)
    end
end
