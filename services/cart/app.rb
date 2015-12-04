class Cart < ActiveRecord::Base
end

class App < Sinatra::Base
  configure do
    register Sinatra::ActiveRecordExtension
    use Rack::Session::Cookie, expire_after: 3600, secret: "salt"
  end

  helpers do
    def csrf_meta_tag
      Rack::Csrf.csrf_metatag(env)
    end

    def param_str(parameters)
      parameters.map { |key, value| key.to_s + "=" + CGI.escape(value.to_s) }.join("&")
    end

    def http_get(endpoint, parameters = {})
      uri = URI.parse(parameters.length > 0 ? endpoint + "?" + param_str(parameters) : endpoint)
      JSON.parse(Net::HTTP.get_response(uri).body, symbolize_names: true)
    rescue
      { error: true }
    end

    def http_post(endpoint, parameters)
      uri = URI.parse(endpoint)
      JSON.parse(Net::HTTP.post_form(uri, parameters).body, symbolize_names: true)
    rescue
      { error: true }
    end

    def endpoint_of(service, action)
      "http://" << service << "/" << action
    end
  end

  post "/carts" do
    content_type :json
    result = { error: false }

    json_params = JSON.parse(request.body.read)
    cart_id = json_params[:carts][:id]
    cart_user_id = json_params[:carts][:user_id]
    cart_item_id = json_params[:carts][:item_id]
    cart = Cart.new()
    cart.save!
    result[:carts] ||= []
    result[:carts] << cart

    result.to_json
  end
end
