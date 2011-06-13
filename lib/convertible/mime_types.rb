module Convertible
  class MimeTypes
    MIME_TYPES = {
      'text/plain' => %w(txt),
      'text/html' => %w(html htm xhtml),
      'text/xml' => %w(xml xsd mxml),
      'text/yaml' => %w(yml yaml),
      'text/csv' => %w(csv),
      'text/rtf' => %w(rtf),
      'image/gif' => %w(gif),
      'image/jpeg' => %w(jpg jpeg jpe),
      'image/png' => %w(png),
      'image/tiff' => %w(tiff tif),
      'image/x-ms-bmp' => %w(bmp),
      'image/x-xpixmap' => %w(xpm),
      'application/pdf' => %w(pdf),
      'application/msword' => %w(doc),
      'application/vnd.ms-excel' => %w(xls),
      'application/vnd.ms-powerpoint' => %w(ppt pps),
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => %w(docx),
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => %w(xlsx),
      'application/vnd.openxmlformats-officedocument.presentationml.presentation' => %w(pptx),
      'application/vnd.openxmlformats-officedocument.presentationml.slideshow' => %w(ppsx),
      'application/vnd.oasis.opendocument.spreadsheet' => %w(ods),
      'application/vnd.oasis.opendocument.text' => %w(odt),
      'application/vnd.oasis.opendocument.presentation' => %w(odp),
      'application/zip' => %w(zip),
      'application/x-gzip' => %w(gz)
    }.freeze

    EXTENSIONS = MIME_TYPES.inject({}) do |map, (type, exts)|
      exts.each {|ext| map[ext] = type}
      map
    end

    ALIASES = {
      'application/pdf' => ['application/x-pdf']
    }

    ALIAS_LOOKUP = ALIASES.inject({}) do |map, (type, aliases)|
      aliases.each {|t| map[t] = type}
      map
    end

    # input is filename
    def self.of(name)
      if name && m = name.to_s.match(/(^|\.)([^\.]+)$/)
        EXTENSIONS[m[2].downcase]
      end
    end

    # input is filename or mime type string (which will be returned as is)
    def self.for(mimetype)
      if MIME_TYPES[mimetype]
        mimetype
      elsif t = ALIAS_LOOKUP[mimetype]
        t
      else
        of(mimetype)
      end
    end

    def self.extension_for(mimetype)
      if exts = MIME_TYPES[self.for(mimetype)]
        exts.first
      end
    end

    def self.main_mimetype_of(name)
      mimetype = of(name)
      mimetype.split('/').first if mimetype
    end

    def self.image?(mimetype)
      self.for(mimetype) =~ /^image\/.+/
    end

    def self.supported?(name_or_mimetype)
      !self.for(name_or_mimetype).blank?
    end

  end
end
