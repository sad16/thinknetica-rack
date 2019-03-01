class TimeFormat
  FORMATS = {
    'year'   => "%Y",
    'month'  => "%m",
    'day'    => "%d",
    'hour'   => "%H",
    'minute' => "%M",
    'second' => "%S"
  }.freeze

  def initialize(formats)
    @formats = formats || default_formats
  end

  def formatted_time
    return unless valid?

    Time.now.strftime(generate_format_string)
  end

  def valid?
    error_formats.empty?
  end

  def error_formats
    @error_formats ||= @formats.reject { |format| FORMATS.include?(format) }
  end

  private

  def default_formats
    FORMATS.keys
  end

  def generate_format_string
    @formats.map { |format| FORMATS[format] }.compact.join('-')
  end
end
