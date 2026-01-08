module OFX
  module Utils
    def self.to_decimal(amount)
      BigDecimal(amount.to_s.gsub(',', '.'))
    rescue ArgumentError
      BigDecimal('0.0')
    end

    # Input format is `YYYYMMDDHHMMSS.XXX[gmt offset[:tz name]]`
    def self.build_date(date)
      return nil if date.to_s.strip.empty?

      tz_pattern = /(?:\[([+-]?\d{1,4}):\S{3}\])?\z/

      # Timezone offset handling
      date.sub!(tz_pattern, '')
      offset = Regexp.last_match(1)

      if offset
        # Offset padding
        _, hours, mins = *offset.match(/\A([+-]?\d{1,2})(\d{0,2})?\z/)
        offset = format('%+03d%02d', hours.to_i, mins.to_i)
      else
        offset = '+0000'
      end

      date << " #{offset}"

      Time.parse(date)
    rescue StandardError
      nil
    end
  end
end