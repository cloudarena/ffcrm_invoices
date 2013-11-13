require 'spec_helper'

describe "invoices/new" do
  before(:each) do
    assign(:invoice, stub_model(Invoice,
      :status => "MyString",
      :tax => "9.99",
      :note => "MyText"
    ).as_new_record)
  end

  it "renders new invoice form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", invoices_path, "post" do
      assert_select "input#invoice_status[name=?]", "invoice[status]"
      assert_select "input#invoice_tax[name=?]", "invoice[tax]"
      assert_select "textarea#invoice_note[name=?]", "invoice[note]"
    end
  end
end
