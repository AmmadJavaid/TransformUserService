class User
  include ActiveModel::Model

  attr_accessor :first_name, :last_name, :email, :phone, :more_data

  EMAIL_REGEX = /\A[^@]+@[^@]+\z/
  PHONE_NUMBER_REGEX = /\A\d{10}\z/

  validates_presence_of :first_name, :last_name
  validates_format_of :phone, with: PHONE_NUMBER_REGEX
  validates_format_of :email, with: EMAIL_REGEX

  def initialize(data)
    self.first_name = data['firstName']
    self.last_name = data['lastName']
    self.email = data['email']
    self.more_data = data['moreData']
    self.phone = data['moreData'].delete('phone')
  end

  def phone=(value)
    return if value.blank?

    @phone = value.gsub(/[^0-9]/, '')
  end

  def format_phone
    "(#{phone[0..2]}) #{phone[3..5]}-#{phone[6..9]}"
  end

  def unique?(records)
    records.each do |record|
      if self.name_match?(record)
        record.collate!(self)
        return false
      end
    end

    true
  end

  def name_match?(record)
    record.first_name == self.first_name && record.last_name == self.last_name
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
      firstName: self.first_name,
      lastName: self.last_name,
      email: self.email,
      phone: self.format_phone,
      moreData: self.more_data
    }
  end

  def valid?
    super

    self.errors.delete(:phone) if self.errors[:email].blank?
    self.errors.delete(:email) if self.errors[:phone].blank?

    self.errors.empty?
  end
end
