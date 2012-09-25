# eXtreme Feedback Device (XFD) is a Build Radiator for Continuous
# Integration servers. Copyright (C) 2010-2012 The Build Doctor Limited.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#require 'rubygems'
require 'sinatra'
class App < Sinatra::Base

  set :static, true
  set :root, File.dirname(__FILE__)
  set :public_folder, File.dirname(__FILE__) + '/target'
  disable :protection

  configure :development, :test do
    set :port, 8081
  end

  configure :production do
    set :port, 80
  end

#config
  class App
    def self.name
      "Fake Jenkins"
    end
  end

  get '/' do
    'Hello.  Not much to see here.'
  end

  get '/version' do
    content_type :json
    version = String(File.read(File.join(File.dirname(__FILE__), 'VERSION'))).strip
    "{\"version\": \"#{version}\"}"
  end

# Example data for all projects.
  get '/hudson/api/json' do
    content_type :json
    reference = params[:jsonp]
    reference + "({\"assignedLabels\":[{}],\"mode\":\"NORMAL\",\"nodeDescription\":\"the master Hudson node\",\"nodeName\":\"\",\"numExecutors\":2,\"description\":null,\"jobs\":[{\"name\":\"Broken Build\",\"url\":\"#{url('/')}job/Broken%20Build/\",\"color\":\"red\"},{\"name\":\"Clean Build\",\"url\":\"#{url('/')}job/Clean%20Build/\",\"color\":\"blue\"}],\"overallLoad\":{},\"primaryView\":{\"name\":\"All\",\"url\":\"#{url('/')}\"},\"slaveAgentPort\":0,\"useCrumbs\":false,\"useSecurity\":false,\"views\":[{\"name\":\"All\",\"url\":\"#{url('/')}\"}]})"
  end

# Example data for a specific job/project.
  get '/job/:job/api/json' do |job|
    content_type :json
    reference = params[:jsonp]
    reference + "({\"displayName\": \"#{job}\",\"name\": \"#{job}\",\"url\": \"#{url('/')}job/#{job}/\",\"lastBuild\": {\"number\": 4,\"url\": \"#{url('/')}job/#{job}/4/\"}})"
  end

# Example data for a specific job's build.
  get '/job/:job/:number/api/json' do |job, number|
    content_type :json
    reference = params[:jsonp]
    reference + "({\"building\": false,\"description\": null,\"duration\": 59042,\"fullDisplayName\": \"#{job} ##{number}\",\"id\": \"2011-12-11_05-30-40\",\"keepLog\": false,\"number\": #{number},\"result\": \"SUCCESS\",\"timestamp\": 1323599440186,\"url\": \"#{url('/')}job/#{job}/#{number}/\",\"culprits\": [{\"absoluteUrl\":\"#{url('/')}user/joe.bloggs\",\"fullName\": \"Joe Bloggs\"}]})"
  end

  get '/user/:name/api/json' do |name|
    content_type :json
    reference = params[:jsonp]
    clean_name = name.gsub(".", " ").split(" ").each { |word| word.capitalize! }.join(" ")
    reference + "({\"absoluteUrl\": \"#{url('/')}user/#{name}\",\"description\": \"Dummy user\",\"fullName\": \"#{clean_name}\",\"id\": \"#{name}\",\"property\": [{\"dummy\": \"data\"},{\"address\": \"test@me.com\"}]})"
  end
end


