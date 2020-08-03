class NovoSga::User < NovoSga::NovoSga
    self.table_name ='public.usuarios'

    def self.get_admin_user_id
        where(admin: true).first.id
    end
end
