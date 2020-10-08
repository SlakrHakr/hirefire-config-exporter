require 'httparty'
require 'json'

response = HTTParty.get('https://api.hirefire.io/applications',
                        headers: {
                          'Authorization': "Token #{ENV.fetch('HIREFIRE_API_TOKEN')}",
                          'Accept': 'application/vnd.hirefire.v1+json',
                          'Content-Type': 'application/json'
                        })
applications = JSON.parse(response.body)['applications']

applications = applications.map do |application|
  response = HTTParty.get("https://api.hirefire.io/applications/#{application['id']}/managers",
                          headers: {
                            'Authorization': 'Token 03b29d55-555e-4c6f-98ef-dc651e26f0bc',
                            'Accept': 'application/vnd.hirefire.v1+json',
                            'Content-Type': 'application/json'
                          })
  managers = JSON.parse(response.body)['managers']

  application.merge({ 'managers': managers })
end

puts JSON.pretty_generate(applications)
