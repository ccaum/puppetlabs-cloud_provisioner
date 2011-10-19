module Puppet::CloudPack::Utils
  class RetryException < Exception

    class RetryException::NoBlockGiven < RetryException
    end

    class RetryException::Timeout < RetryException
    end

    class RetryException::OutOfRetries < RetryException
    end
  end
  
  def self.retry_action( parameters = { :retry_exceptions => Hash.new, :timeout => nil } )
    # Helper method to retry actions n number of times, re-raise the exception
    # after the retry count has been met.
    unless block_given?
      raise RetryException::NoBlockGiven
    end

    start = Time.now
    failures = 0

    begin
      yield
    rescue Exception => e 
      #If we were giving exceptions to catch,
      #catch the excptions we care about and retry.
      #All others fail hard
      if (not parameters[:retry_exceptions].keys.empty?) and parameters[:retry_exceptions].keys.include?(e)

        #If the max run time was specifed and we haven't run out
        unless parameters[:timeout].nil? and ( (Time.now - start) < parameters[:timeout] )
          raise RetryException::Timeout 
        end
          
        Puppet.info("Caught exception #{e}")
        Puppet.info(parameters[:exception][e])
      elsif (not parameters[:retry_exceptions].keys.empty?)
        raise e
      end

      failures += 1
      
      sleep (((2 ** failures) -1) * 0.1)

      retry

    end
  end
end
