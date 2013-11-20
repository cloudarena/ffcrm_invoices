

class  InvoiceCallback < FatFreeCRM::Callback::Base

  def inline_styles view, context
   # view.controller.render_to_string :partial=>"inline_styles", :locals => context
  end
end
