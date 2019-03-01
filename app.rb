require_relative 'lib/time_format'

class App
  REQUEST_METHOD = 'GET'.freeze
  TIME_PATH = '/time'.freeze

  def call(env)
    return not_found unless time_request?(env)

    time_format = TimeFormat.new(time_format_options(env))

    if time_format.valid?
      ok(time_format.to_s)
    else
      bad_request(time_format.error_message)
    end
  end

  private

  def time_request?(env)
    env['REQUEST_METHOD'] == REQUEST_METHOD && env['PATH_INFO'] == TIME_PATH
  end

  def time_format_options(env)
    time_params(env)['format']&.split(',')
  end

  def time_params(env)
    decode_query_string = URI::decode(env['QUERY_STRING'])
    decode_query_string.split('&').map { |param| param.split('=') }.to_h
  end

  def not_found
    response(status: 404)
  end

  def ok(body)
    response(status: 200, body: body)
  end

  def bad_request(body)
    response(status: 400, body: body)
  end

  def response(status:, headers: { 'Content-Type' => ' text/plain' }, body: nil)
    [status, headers, [body]]
  end
end
