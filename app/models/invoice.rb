class Invoice < ActiveRecord::Base
  attr_accessible :invoice_date, :note, :order_date, :payment_due_date, :status, :tax
end
