module Slapme
  module Storage
    class NotFound < StandardError; end

    require 'slapme/storage/file_system'
  end
end
