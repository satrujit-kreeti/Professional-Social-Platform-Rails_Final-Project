module ApplicationHelper
  def link_to_add_certificate(name, f, association, **options)
    certificate_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, certificate_object, child_index: 'new_certificate') do |certificate_fields|
      render('certificate_fields', certificate_fields:)
    end
    options[:data] = { association:, fields: fields.delete("\n") }
    link_to(name, '#', class: 'add-certificate', **options)
  end
end
