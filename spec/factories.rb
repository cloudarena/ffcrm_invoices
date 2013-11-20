
#---------------------------------------------------------------
Factory.define :invoice do |i|
  i.user    {|a| a.association(:user)}
  i.account  { |a| a.association(:account) }

  i.access "Public"
  i.status                      { Setting.invoice_setatus.rand }
  i.uniqid                    { Invoice.make_unique_id }

  i.invoice_date            { Factory.next(:time)}
  i.payment_due_date { Factory.next(:time) }
  i.order_number        { rand(100000) }
  i.order_date            { Factory.next(:time) }

  i.tax                        { rand(0, 1.0) }
  i.note                       { Faker::Lorem.sentence[0..63] }

  i.created_at             { Factory.next(:time) }
  i.updated_at            { Factory.next(:time) }
  
end
    
   
