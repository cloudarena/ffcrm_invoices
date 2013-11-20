class Invoice < ActiveRecord::Base
  # mass assignment
  attr_accessible :user_id, :account_id, :access
  attr_accessible :uniqid, :status, :invoice_date, :payment_due_date, :order_number, :order_date, :tax, :note

  # invoice has a creator
  # invoice belongs to a count
  # invoice may have no opporunities or more than one opportunities.
  # invoice have its tasks, which is different task to opportuntiy, so delete invoice will delete the invoice task.
  belongs_to   :user
  belongs_to   :account
  has_many    :invoice_opportunities, :dependent => :destroy
  has_many    :opportunities, :through => :invoice_opportunities, :uniq => true, :order => "opportunity_id DESC"
  has_many    :tasks, :as => :asset, :dependent => :destroy
  
  # validations
  validates_presence_of :user_id, :account_id
  validates_presence_of :uniqid, :status, :invoice_date, :payment_due_date
  validates :uniqid, :presence=>true, :uniqueness=>true

  # scopes
  year=Time.now.strftime("%Y")
  scope :thisyear, lambda { {:conditions => ["created_at > '01/01/#{year}'"] }}
  scope :my, lambda { accessible_by(User.current_ability) }

  # extensions
  has_ransackable_associations %w(account opportunities activities comments tasks)
  ransack_can_autocomplete
  acts_as_commentable
  has_paper_trail :ignore => [ :subscribed_users ]
  sortable :by => ['invoice_date DESC'], :default => 'created_at DESC'


  # save invoice with account info.
  #------------------------------------
  def save_with_account(params)
    params[:account].delete(:id) if params[:account][:id].blank?
    account = Account.create_or_select_for(self, params[:account])
    # may be account_invoice relation
    self.account = account
    self.save
  end

  # make a unique_id of invoice
  #-------------------------------------
  def self.make_unique_id
    no = Setting.invoice_sequence_number
    no = Invoice.count if no.nil?
    changed = false
    while where(:uniqid =>"#{Setting.invoice_stem}_#{no}").exists? do
      no += 1
      changed = true
    end
    Setting.invoice_sequence_number = no if changed
    "#{Setting.invoice_stem}_#{no}"
  end


  #-------------------------------------
  def self.per_page; 20; end
  def emails; []; end
  def email_ids; []; end
  def subscribed_users; []; end
  def full_name; uniqid; end
  def name; uniqid; end


  #-----------------------------------
  def attach!(attachment)
    unless self.send("#{attachment.class.name.downcase}_ids").include?(attachment.id)
      self.send(attachment.class.name.tableize) << attachment
    end
  end

  #---------------------------------------
  def discard!(attachment)
    if attachment.is_a?(Task)
      attachment.update_attribute(:asset, nil)
    else # 
      self.send(attachment.class.name.tableize).delete(attachment)
    end
  end

  ActiveSupport.run_load_hooks(:fat_free_crm_invoice, self)
end
