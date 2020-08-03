class MoneyType < ActiveRecord::Type::Decimal
  def cast(value)
    if !value.kind_of?(Numeric)
      value.gsub!('R$', '') if value.include?('R$')
      value.gsub!('.', '') if value.include?('.')
      value.gsub!(',', '.') if value.include?(',')
      super(value.strip.to_f)
    else
      super
    end
  end

  def deserialize(value)
    value
  end
end