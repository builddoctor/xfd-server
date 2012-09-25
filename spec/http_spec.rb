$: << File.join(File.dirname(__FILE__), '..')
require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'app'
require 'json'

#set :environment, :test

describe 'The XFD Server App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should see the index page without mch" do
    get '/'
    last_response.should be_ok
    last_response.body.should match("Hello.")
  end

  it "should find a version" do
    get '/version'
    JSON.parse(last_response.body)['version'].should == '1000-local'
  end

  def remove_jsonp_function(string)
    string.gsub(/^googoo\(/, '').gsub(/\)$/, '')
  end
  it "should get a json hash if you give it a /hudson URL" do
    get '/hudson/api/json?jsonp=googoo'
    JSON.parse(remove_jsonp_function(last_response.body))['jobs'].first['url'].should == 'http://example.org/job/Broken%20Build/'
  end

  it "should get a json hash  if you ask it for a jenkins job" do
    get '/job/foobar/api/json?jsonp=googoo'
    JSON.parse(remove_jsonp_function(last_response.body))['url'].should == 'http://example.org/job/foobar/'
  end

  it "should also support getting a build by id" do
    get '/job/goon/6/api/json?jsonp=googoo'
    JSON.parse(remove_jsonp_function(last_response.body))['result'].should == 'SUCCESS'
  end

  it "should also support getting a user by name" do
    get '/user/bob/api/json?jsonp=googoo'
    JSON.parse(remove_jsonp_function(last_response.body))['fullName'].should == 'Bob'
  end

end