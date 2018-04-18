SmartcatSDK::Util::Extensions.list.each do |type|
  mime_type = type['mime-type']
  name = type['name']
  next unless mime_type
  MIME::Types.add(MIME::Type.new(mime_type)) if MIME::Types[mime_type].empty?
  MIME::Types[mime_type].first.add_extensions(name)
end
