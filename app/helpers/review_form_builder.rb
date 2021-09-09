class ReviewFormBuilder < ValidatedFormBuilder
  def rating_field(name, **options)
    options.reverse_merge! max_stars: 5, class: "", required: false
    @template.render "shared/form/rating_control",
      f: self, name: name, classes: options[:class], **options
  end
end
