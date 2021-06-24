class ApplicationController < ActionController::Base

  def self.crudify(index_attributes: nil, only: nil, permit_params: nil)
    include CrudConcern
    if index_attributes
      define_method :index_attribute_names do
        index_attributes
      end
    end
    actions = %i[index show edit new destroy create update]
    actions = actions & [*only].map(&:to_sym) if only
    actions.each do |nam|
      logger.info "#{nam.capitalize}Action"
      include CrudConcern.const_get("#{nam.capitalize}Action")
    end
    if permit_params.present?
      klassname = name.split('Controller').first.singularize
      define_method "#{klassname.underscore}_params" do
        params.require(klassname.underscore).permit(permit_params)
      end
    end
  end

end
