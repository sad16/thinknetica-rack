require_relative 'lib/time_format'

class App
  def call(env)
    request = Rack::Request.new(env)

    return not_found unless request.get? && request.path == '/time'

    time_format = TimeFormat.new(request.params['format']&.split(','))

    if time_format.valid?
      ok(time_format.formatted_time)
    else
      bad_request("Unknown time format [#{time_format.error_formats.join(',')}]")
    end
  end

  private

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
    [status, headers, ["#{body}\n"]]
  end
end
