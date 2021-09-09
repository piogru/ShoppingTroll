class ValidatedFormBuilder < ActionView::Helpers::FormBuilder
  def validation_feedback(name)
    @template.render "shared/form/validation_feedback", object: object, name: name
  end
end
