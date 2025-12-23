require 'json'

class ForumExporter
  class JSONWriter
    def initialize(filename, headers)
      @filename = filename
      @headers = headers
      @records = []

      # Ensure directory exists
      FileUtils.mkdir_p(File.dirname(filename))
    end

    def write_row(data)
      # Convert array of values to hash using headers
      record = Hash[@headers.zip(data)]
      @records << record
    end

    def close
      # Write all records to file as JSON array
      File.write(@filename, JSON.pretty_generate(@records))
    end
  end
end
