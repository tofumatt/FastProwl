require 'rubygems'
require 'typhoeus'

# Create a FastProwl instance and iPhone-spam away via Prowl! ;-)
class FastProwl
  
  class MissingAPIKey < Exception; end
  class PriorityOutOfRange < Exception; end
  class TooManyAPIKeys < Exception; end
  
  API_URL = 'https://prowl.weks.net/publicapi/'
  PRIORITY_RANGE = -2..2
  # You can change this using the user_agent() method
  USER_AGENT = 'FastProwl 0.3 (http://github.com/tofumatt/FastProwl)'
  
  # Supply Prowl defaults in a hash (:apikey, :providerkey, etc.), along
  # with optional Typhoeus Hydra options.
  def initialize(defaults = {}, hydra = {})
    @defaults = defaults
    @responses = []
    @hydra = Typhoeus::Hydra.new(hydra)
    @user_agent = USER_AGENT
  end
  
  # Queue a notification request in the Hydra.
  def add(params = {})
    @hydra.queue(request('add', params))
  end
  
  # Modify this instance's defaults
  def defaults(params)
    @defaults = @defaults.merge(params)
  end
  
  # Run all queued Hydra requests.
  def run
    @hydra.run
    status
  end
  
  # Change the user-agent sent to the Prowl server.
  def user_agent(user_agent)
    @user_agent = user_agent
  end
  
  # Queue a verify API call in the Hydra.
  def valid?
    @hydra.queue(request('verify'))
  end
  
  # Send a single Prowl notification _immediately_.
  def self.add(params = {})
    prowl = new
    prowl.add(params)
    prowl.run
  end
  
  # Verify a Prowl API key _immediately_. Returns true if the key is
  # valid; false otherwise.
  def self.verify(apikey)
    prowl = new(:apikey => apikey)
    prowl.valid?
    prowl.run
  end
  
  private
  
  # Setup and return a Typhoeus HTTP request
  def request(action, params = {})
    # Merge the default params with any custom ones
    params = @defaults.merge(params) unless !@defaults
    
    # Exception checks
    if !params[:apikey] || (params[:apikey].is_a?(Array) && params[:apikey].size < 1)
      raise MissingAPIKey
    end
    
    if params[:priority] && !PRIORITY_RANGE.include?(params[:priority])
      raise PriorityOutOfRange
    end
    
    # Raise an exception if we're trying to use more API keys than allowed for this action
    if params[:apikey].is_a?(Array) && ((action == 'verify' && params[:apikey].size > 1) || params[:apikey].size > MAX_API_KEYS)
      raise TooManyAPIKeys
    end
    
    # If there are multiple API Keys in an array, merge them into a comma-delimited string
    if params[:apikey].is_a?(Array)
      params[:apikey] = params[:apikey].collect{|v| v + ',' }.to_s.chop
    end
    
    # Delete any empty key/value sets
    params.delete_if {|key, value| value.nil? }
    
    # Make the request
    req = Typhoeus::Request.new(API_URL + action,
      :user_agent => @user_agent,
      :method => (action == 'add') ? :post : :get,
      :params => (action == 'add') ? params : {:apikey => params[:apikey]}
    )
    
    # Typhoeus request on_complete method adds the HTTP code to an array
    req.on_complete do |response|
      @responses << response.code
    end
    
    # Return the request
    req
  end
  
  # Check to see if any notifications succeeded. Like the Prowl API with multiple
  # API keys, we'll only return false if *zero* requests succeeded.
  def status
    return false if !@responses.include?(200)
    
    true
  end
  
end
