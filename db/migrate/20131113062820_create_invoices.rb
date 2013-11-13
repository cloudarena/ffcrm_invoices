class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :status
      t.date :invoice_date
      t.date :order_date
      t.decimal :tax
      t.date :payment_due_date
      t.text :note

      t.timestamps
    end
  end
end
