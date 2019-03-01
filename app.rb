require_relative 'lib/time_format'

class App
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

  def not_found
    [404, {}, []]
  end

  def time_request?(env)
    env['REQUEST_METHOD'] == 'GET' && env['PATH_INFO'] == '/time'
  end

  def time_format_options(env)
    time_params(env)['format']&.split(',')
  end

  def time_params(env)
    URI::decode(env['QUERY_STRING']).split('&').map { |param| param.split('=') }.to_h
  end

  def ok(body)
    [200, { 'Content-Type' => ' text/plain' }, [body]]
  end

  def bad_request(body)
    [400, { 'Content-Type' => ' text/plain' }, [body]]
  end
end
