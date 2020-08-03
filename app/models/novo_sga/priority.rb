class NovoSga::Priority < NovoSga::NovoSga
    self.table_name ='public.prioridades'

    def self.get_normal_priority_id
        where("nome iLIKE ?", "%normal%").first.id
    end
end
