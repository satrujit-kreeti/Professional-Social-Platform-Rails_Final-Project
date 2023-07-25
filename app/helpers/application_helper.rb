# frozen_string_literal: true

module ApplicationHelper
  def link_to_add_certificate(name, form, association, **options)
    certificate_object = form.object.class.reflect_on_association(association).klass.new
    fields = form.fields_for(association, certificate_object, child_index: 'new_certificate') do |certificate_fields|
      render('certificate_fields', certificate_fields:)
    end
    options[:data] = { association:, fields: fields.delete("\n") }
    link_to(name, '#', class: 'add-certificate', **options)
  end
end
