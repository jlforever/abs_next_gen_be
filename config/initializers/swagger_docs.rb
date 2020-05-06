include Swagger::Docs::ImpotentMethods

class Swagger::Docs::Config
  def self.base_api_controller
    ActionController::API 
  end
end

Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the extension used for the API
    :api_extension_type => :json,
    # the output location where your .json files are written to
    :api_file_path => "public/api/v1/",
    # the URL base path to your API
    :base_path => "http://api.somedomain.com",
    # if you want to delete all .json files at each generation
    :clean_directory => false,
    # add custom attributes to api-docs
    :attributes => {
      :info => {
        "title" => "ABS Next Gen Backend",
        "description" => "This is the ABS next generation backend repository API doc",
        "termsOfServiceUrl" => "http://helloreverb.com/terms/",
        "contact" => "admin@alphabetaschool.org",
        "license" => "Apache 2.0",
        "licenseUrl" => "http://www.apache.org/licenses/LICENSE-2.0.html"
      }
    }
  }
})
