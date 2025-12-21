require 'csv'

class ForumExporter
  class CSVWriter
    def initialize(filename, headers)
      @filename = filename
      @headers = headers

      # Ensure directory exists
      FileUtils.mkdir_p(File.dirname(filename))

      # Open CSV with UTF-8 encoding
      @csv = CSV.open(filename, 'w', write_headers: true, headers: headers, encoding: 'UTF-8')
    end

    def write_row(data)
      @csv << data
    end

    def close
      @csv.close
    end
  end
end
