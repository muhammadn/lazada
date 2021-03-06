module Lazada
  module API
    module Image
      def set_images(params)
        url = request_url('Image')

        params = { 'ProductImage' => params }
        response = self.class.post(url, body: params.to_xml(root: 'Request', skip_types: true))

        response
      end

      def migrate_image(image_url)
        url = request_url('MigrateImage')

        params = { 'Image' => { 'Url' => image_url } }
        response = self.class.post(url, body: params.to_xml(root: 'Request', skip_types: true))

        if ENV['RAILS_ENV'].present?
          raise StandardError, response['ErrorResponse']['Head']['ErrorMessage'] if response['ErrorResponse']
        else
          raise RuntimeError, response['ErrorResponse']['Head']['ErrorMessage'] if response['ErrorResponse']
        end
        response['SuccessResponse'].present? ? response['SuccessResponse']['Body']['Image']['Url'] : ''
      end
    end
  end
end
