class InvoicesController < EntitiesController

  before_filter :load_settings
  before_filter :set_params, :only => [:index,:redraw]


  # GET /invoices
  # GET /invoices.xls
  # GET /invoices.csv
  # GET /invoices.rss
  # GET /invoices.atom
  #-------------------------------------------
  def index
    @invoices = get_invoices(:page => params[:page], :per_page =>params[:per_page])

    respond_with @invoices do |format|
      format.xls { render :layout => 'header' }
      format.csv { render :csv => @invoices }
    end
  end

  # GET /invoices/1
  # AJAX  /invoices/1
  #-----------------------------------------
  def show
    @invoice = Invoice.find(params[:id])
    @timeline = timeline(@invoice)
    respond_with(@invoice)
  end

  # GET /invoices/new
  # AJAX /invoices/new
  #-----------------------------------------
  def new
    @invoice.attributes = {:user=>current_user}
    @account     = Account.new(:user => current_user, :access => Setting.default_access)
    @accounts    = Account.my.order('name')
    @invoice.user_id = current_user.id
    @invoice.uniqid = next_unique_id
    @invoice.user_id = current_user.id
    respond_with(@invoice)
  end

  # GET /invoices/1/edit
  #---------------------------------------------
  def edit
    # prepare current infor to edit
    @account = @invoice.account

    # for account _select
    @accounts    = Account.my.order('name')

    # retrieve previous model if any, so that we render previous info (close its form)
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Invoice.my.find_by_id($1) || $1.to_i
    end

    respond_with(@invoice)
  end

  # POST /invoices
  #----------------------------------------------------------
  def create
    # create invoice
    @invoice = Invoice.new(params[:invoice])
    @invoice.user_id = current_user.id if @invoice.user_id.blank?

    # create account if neccessaory, and assoc with invoice
    if @invoice.save_with_account(params)
      set_options
      @invoices = get_invoices
    else  # fail to save
      @accounts = Account.my.order('name')
      unless params[:account][:id].blank?
        @account = Account.find(params[:account][:id])
      else
          if request.referer =~ /\/accounts\/(.+)$/
            @account = Account.find($1) # related account
          else
            @account = Account.new(:user => current_user)
          end
      end
    end

  end

  # PUT /invoices/1
  #-------------------------------------------------------
  def update
    @invoice.update_attributes(params[:invoice])
  end

  # DELETE /invoices/1
  #-------------------------------------------------------
  def destroy
    @invoice.destroy
    set_options
    @invoices = get_invoices(:page => params[:page], :per_page =>params[:per_page])
    respond_with(@invoices) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # POST|AJAX /invoices/redraw
  #-------------------------------------------------------
  def redraw
    @invoices = get_invoices(:page =>1, :per_page => params[:per_page])
    set_options
    respond_with(@invoices) do |format|
      format.js { render :index }
    end
  end


  def next_unique_id
     Invoice.make_unique_id
  end

  def load_settings
    @status = Setting.unroll(:invoice_status)
    @tax_options = Setting[:invoice_tax_options]
  end

  private
  alias :get_invoices   :get_list_of_records

  def respond_to_destroy(method)
    if method == :ajax
      if called_from_index_page?
        get_data_for_sidebar
        @opportunities = get_invoices
        if @opportunities.blank?
          @opportunities = get_invoices(:page => current_page - 1) if current_page > 1
          render :index and return
        end
      else # Called from related asset.
        self.current_page = 1
      end
      # At this point render destroy.js
    else
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @opportunity.name)
      redirect_to invoices_path
    end
  end
    

  def get_data_for_sidebar(related = false)
  end


  def set_params
    current_user.pref[:invoices_per_page] = params[:per_page] if params[:per_page]
  end
end
