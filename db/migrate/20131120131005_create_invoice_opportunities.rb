class CreateInvoiceOpportunities < ActiveRecord::Migration
  def change
    create_table :invoice_opportunities do |t|
      t.references :invoice
      t.references :opportunity

      t.timestamps
    end
    add_index :invoice_opportunities, :invoice_id
    add_index :invoice_opportunities, :opportunity_id
  end
end
