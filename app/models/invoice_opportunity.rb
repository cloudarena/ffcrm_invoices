class InvoiceOpportunity < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :opportunity
  # attr_accessible :title, :body
  validates_presence_of :invoice_id, :opportunity_id
  
  ActiveSupport.run_load_hooks(:fat_free_crm_invoice_opportunity, self)
end
