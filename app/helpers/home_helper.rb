module HomeHelper
    def show_height(minimum_height, maximum_height)
        return minimum_height if maximum_height.blank?
        "#{minimum_height}-#{maximum_height}"
    end

    def show_minimum_and_maximum_values(minimum_value, maximum_value)
        minimum_value = (!minimum_value.blank? && minimum_value > 0) ? "+#{minimum_value}" : ''
        maximum_value = (!maximum_value.blank? && maximum_value > 0) ? "+#{maximum_value}" : ''
        "#{minimum_value} #{maximum_value}"
    end

    def check_if_has_video(characteristic)
        if characteristic.video_link.empty?
            content_tag(:div, characteristic.description, class: "slider-item-title", title: "Não há vídeo cadastrado")
        else
            content_tag(:a, characteristic.description, href: characteristic.video_link, target: "_blank", class: "slider-item-title", title: "Clique para abrir o vídeo")
        end
    end

    def check_if_has_attachment(characteristic)
        if characteristic.attachment.present?
            link_to image_tag(characteristic.image.url, title: "Clique para abrir o arquivo"), characteristic.attachment.url(:original, false), target: "_blank"
        else
            image_tag(characteristic.image.url, title: "Não há arquivo cadastrado")
        end
    end

    def show_details(glass)
        details = Hash.new
        details["Ean: "] = glass.ean if !glass.ean.to_s.empty?
        details["Prazo para entrega: "] = glass.delivery_time if !glass.delivery_time.to_s.empty?
        details["Comissão: "] = glass.commission_percentage if !glass.commission_percentage.to_s.empty?
        details[:archieve] = glass.marking if glass.marking.present?
        details
    end

end
