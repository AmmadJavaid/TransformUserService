class User
  include ActiveModel::Model

  attr_accessor :first_name, :last_name, :email, :phone, :more_data

  EMAIL_REGEX = /\A[^@]+@[^@]+\z/

  validates_presence_of :first_name, :last_name
  validates_format_of :phone, with: /\d{10}/
  validates_format_of :email, with: EMAIL_REGEX

  def initialize(data)
    self.first_name = data['firstName']
    self.last_name = data['lastName']
    self.email = data['email']
    self.more_data = data['moreData']
    self.phone = data.dig('moreData', 'phone')
  end

  def format_phone
    "(#{phone[0..2]}) #{phone[3..5]}-#{phone[6..10]}"
  end

  def unique?(records)
    records.each do |record|
      if record.first_name == first_name && record.last_name == last_name
        record.collate!(self)
        return false
      end
    end

    true
  end

  def valid?
    super
    self.errors.delete(:phone) if self.errors[:email].blank?
    self.errors.delete(:email) if self.errors[:phone].blank?

    self.errors.empty?
  end

  def collate!(duplicate)
    self.email ||= duplicate.email
    self.phone ||= duplicate.phone
    self.more_data.merge!(duplicate.more_data)
  end

  def to_json(*a)
    as_json.to_json(*a)
  end

  def as_json(options = {})
    {
      "firstName": self.first_name,
      "lastName": self.last_name,
      "email": self.email,
      "phone": self.format_phone,
      "moreData": self.more_data
    }
  end
end
