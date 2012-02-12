###########################
# Internationalize Configs
###########################

module I18n
  class << self
    def is_true_or_false(true_false_value)
      if (true_false_value == true)
        I18n.translate('view_field_value.true')
      else
        I18n.translate('view_field_value.false')
      end
    end
    def is_deactivated_or_not(true_false_value)
      if (true_false_value == true)
        I18n.translate('view_field_value.deactivated')
      else
        I18n.translate('view_field_value.reactivated')
      end
    end
  end
end



