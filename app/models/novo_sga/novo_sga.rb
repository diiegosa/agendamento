class NovoSga::NovoSga < ApplicationRecord
    self.abstract_class = true
    establish_connection :novo_sga
end
