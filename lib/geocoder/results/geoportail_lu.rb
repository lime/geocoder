require 'geocoder/results/base'

module Geocoder::Result
  class GeoportailLu < Base

    def coordinates
      geomlonlat['coordinates'].reverse if geolocalized?
    end

    def address
      full_address
    end

    def city
      try_to_extract 'locality', detailled_address
    end

    def state
      'Luxembourg'
    end

    def state_code
      'LU'
    end

    def postal_code
      try_to_extract 'zip', detailled_address
    end

    def street_address
      [street_number, street].compact.join(' ')
    end

    def street_number
      try_to_extract 'postnumber', detailled_address
    end

    def street
      try_to_extract 'street', detailled_address
    end

    def full_address
      data['address']
    end

    def geomlonlat
      data['geomlonlat']
    end

    def detailled_address
      data['AddressDetails']
    end

    alias_method :country, :state
    alias_method :province, :state
    alias_method :country_code, :state_code
    alias_method :province_code, :state_code

    private

    def geolocalized?
      coordinates = try_to_extract('coordinates', geomlonlat)
      !coordinates.nil? && !coordinates.empty?
    end

    def try_to_extract(key, nullable_hash)
      if nullable_hash.nil?
        nil
      else
        nullable_hash[key]
      end
    end
  end
end
