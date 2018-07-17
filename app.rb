require 'sinatra/base'
require 'pg'

class ThermostatServer < Sinatra::Base
  enable :sessions
  set :session_secret, 'secretsss'

  post '/data' do
    headers 'Access-Control-Allow-Origin' => '*'
    PG.connect(dbname: "thermostat").exec("DELETE FROM settings")
    PG.connect(dbname: "thermostat").exec("INSERT INTO settings (temperature, psm) VALUES (#{params[:temp]}, #{params[:psm]})")
  end

  get '/data' do
    headers 'Access-Control-Allow-Origin' => '*'
    data = PG.connect(dbname: "thermostat").exec("SELECT * FROM settings").first
    psm = (data["psm"] == "t")
    return_message = { temp: data["temperature"], psm: psm }
    return_message.to_json
  end
end
