class CustomError

  class NoSearchResultError < StandardError
  end
  
  class GeoProviderError < StandardError
  end
  
  class AddressEmpty < StandardError
  end
end