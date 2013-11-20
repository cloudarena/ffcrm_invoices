class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :user
      t.references :account

      t.string :uniqid, :limit=>64, :null => false
      t.string :status, :limit=>32

      t.date :invoice_date
      t.date :payment_due_date
      t.integer  :order_number
      t.date :order_date

      t.decimal :tax, :precision=>12, :scale => 2
      t.text :note

      t.string :access, :limit=>8, :default => "Public"
      t.timestamps
    end

    add_index :invoices, [:uniqid], :unique =>true, :name => "uniq_invoice_uniqid"
  end
end
