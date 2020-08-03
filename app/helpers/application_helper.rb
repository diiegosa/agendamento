module ApplicationHelper

  def translate_module(model, number = :one)
    t(number, scope: [:activerecord, :models, model.downcase])
  end

  def translate_attr(attribute, model)
    t(attribute, scope: [:activerecord, :attributes, model.downcase])
  end

  def translate_action(action)
    t(action.downcase, scope: [:actions])
  end

  def translate_message(msg)
    t(msg, scope: [:message])
  end

end
