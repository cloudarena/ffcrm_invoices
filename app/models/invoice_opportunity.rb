class InvoiceOpportunity < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :opportunity
  # attr_accessible :title, :body
end
