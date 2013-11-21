xml.Worksheet 'ss:Name' => I18n.t(:tab_invoices) do
  xml.Table do
    unless @invoices.empty?
      # Header.
      xml.Row do        
        heads = [I18n.t('user'),
                 I18n.t('account'),
                 I18n.t('uniqid'),
                 I18n.t('status'),
                 I18n.t('invoice_date'),
                 I18n.t('payment_due_date'),
                 I18n.t('order_number'),
                 I18n.t('order_date'),
                 I18n.t('tax'),
                 I18n.t('note'),
                 I18n.t('created_at'),
                 I18n.t('updated_at')]                            

        heads.each do |head|
          xml.Cell do
            xml.Data head,
            'ss:Type' => 'String'
          end
        end
      end                                                                                       

      # Inovice rows
      @invoices.each do |invoice|
        xml.Row do
          data = [invoice.user.try(:name),
                  invoice.account.try(:name),
                  invoice.uniqid,
                  invoice.status,
                  invoice.invoice_date,
                  invoice.payment_due_date,
                  invoice.order_number,
                  invoice.order_date,
                  invoice.tax,
                  invoice.note,
                  invoice.created_at,
                  invoice.updated_at
                 ]
          data.each do |value|
            xml.Cell do
              xml.Data value, 'ss:Type' => "#{value.respond_to?(:abs) ? 'Number' : 'String'}"
            end
          end
        end
      end

    end
  end
end
