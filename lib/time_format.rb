class TimeFormat
  DATE_FORMAT_OPTIONS = {
    'year'   => "%Y",
    'month'  => "%m",
    'day'    => "%d"
  }.freeze

  TIME_FORMAT_OPTIONS = {
    'hour'   => "%H",
    'minute' => "%M",
    'second' => "%S"
  }.freeze

  FORMAT_OPTIONS = DATE_FORMAT_OPTIONS.merge(TIME_FORMAT_OPTIONS).freeze

  def initialize(format_options)
    @format_options = format_options || default_format_options
  end

  def to_s
    return unless valid?

    Time.now.strftime(generate_format_string)
  end

  def valid?
    error_formats.empty?
  end

  def error_message
    "Unknown time format [#{error_formats.join(',')}]"
  end

  private

  def default_format_options
    FORMAT_OPTIONS.keys
  end

  def generate_format_string
    date = select_format_values(DATE_FORMAT_OPTIONS).join('-')
    time = select_format_values(TIME_FORMAT_OPTIONS).join(':')
    "#{date} #{time}".strip
  end

  def select_format_values(allowed_format_options)
    @format_options.map { |option| allowed_format_options[option] }.compact
  end

  def error_formats
    @error_formats ||= @format_options.select { |option| !FORMAT_OPTIONS.include?(option) }
  end
end
