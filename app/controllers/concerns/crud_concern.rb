module CrudConcern

  module IndexAction
    def index
      self.current_objects = klass.all
      instance_variable_set "@#{klassname.tableize}", self.current_objects
    end
  end

  module ShowAction
    def show
    end
  end

  module EditAction
    def edit
    end
  end

  module NewAction
    def new
      instance_variable_set "@#{klassname.underscore}", klass.new
    end
  end

  module DestroyAction
    def destroy
      current_object.destroy
      respond_to do |format|
        format.html { redirect_to current_index_url, notice: "#{klassname} was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  module CreateAction
    def create
      oparams = send("#{klassname.underscore}_params")
      new_object = klass.new(oparams)

      respond_to do |format|
        if new_object.save
          format.html { redirect_to new_object, notice: "#{klassname} was successfully created." }
          format.json { render :show, status: :created, location: new_object }
        else
          self.current_object = new_object
          instance_variable_set "@#{klassname.underscore}", self.current_object
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  module UpdateAction
    def update
      oparams = send("#{klassname.underscore}_params")
      new_object = klass.new(oparams)

      respond_to do |format|
        if current_object.update(oparams)
          format.html { redirect_to current_object, notice: "#{klassname} was successfully updated." }
          format.json { render :show, status: :ok, location: current_object }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: current_object.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def set_current_object
    logger.info "CrudConcern: set_current_object"
    self.current_object = klass.find(params[:id])
    instance_variable_set "@#{klassname.underscore}", self.current_object
  end

  def klassname()
    @_klassname = self.class.name.split('Controller').first.singularize
  end

  def klass()
    @_klass = klassname.constantize
  end

  def index_attribute_names
    klass.attribute_names - ['created_at', 'updated_at']
  end

  private def current_index_url
    send "#{klassname.tableize}_url"
  end

  def self.included(by)
    by.before_action :set_current_object, only: %i[ show edit update destroy ]
    by.attr_accessor :current_object, :current_objects
    by.helper_method :klass
    by.helper_method :klassname
    by.helper_method :current_object
    by.helper_method :current_objects
    by.helper_method :index_attribute_names
    by.helper_method :show_attribute_names
    by.helper_method :current_index_url
  end

end
