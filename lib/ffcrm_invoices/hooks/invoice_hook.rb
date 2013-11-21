

class  InvoiceCallback < FatFreeCRM::Callback::Base

  # hook to inject invoices status css into page.
  def inline_styles view, context
    view.controller.render_to_string :partial=>"invoices/inline_styles", :locals => context
  end


  def auto_complete controller, options
    controller.instance_eval {
      # extract parameters
      related_class, id = params[:related].split('/')
      related_klass = related_class.classify.constantize
      obj = related_klass.find_by_id(id)
      exclude_ids = auto_complete_ids_to_exclude(params[:related])

      # 1st, restrict scope to my access
      @auto_complete = klass.my

      # deal with different controllr
      case controller.controller_name
        #opportunies
      when "opportunities" then  # hook 'opportunity' auto_complete
        exclude_ids = auto_complete_ids_to_exclude(params[:related])
        
        # For related obj is invoice, as invoice has associated account.
        # auto_complete only select 'closed/won' opportunities that belongs to the account.
        if related_klass == Invoice
          # select only 'closed/won' opportunity
          @auto_complete =  @auto_complete.won.joins(:account_opportunity).where("account_opportunities.account_id = ?", obj.account.id)
        end
        
      end

      # support '*' to return all 
      @auto_complete = @auto_complete.text_search(@query)  if @query.strip != "*"
      @auto_complete = @auto_complete.search(:id_not_in => exclude_ids).result.limit(10)
        
    }
  end

  #  hook to inject invoices to opportuntiy detail page
  insert_before :show_opportunity_bottom do |view, context|
    view.instance_eval {
      controller.render_to_string :partial=> "invoices/invoices", :locals =>{:object=> @opportunity}
    }
  end

  insert_after :show_opportunity_bottom do |view, context|
    view.instance_eval { 
      load_select_popups_for(@opportunity, :invoices)
    }
  end

  insert_before :show_account_bottom do |view, context|
    view.instance_eval { 
      controller.render_to_string :partial=> "invoices/invoices", :locals =>{:object=> @account}
    }
  end

end
