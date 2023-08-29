class Urlset < ApplicationRecord
  belongs_to :block

  # nameとaddressの両方が存在するまたは存在しない場合にのみバリデーションを適用
  validates :name, presence: { if: :address_present? }
  validates :address, presence: { if: :name_present? }
  
  validate :ensure_unique_name_within_block
  validate :ensure_unique_address_within_block

  validates_format_of :address, with: /\A(?:(?:https?|ftp):\/\/)?(?:\S+(?::\S*)?@)?(?:localhost|(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\/|\/\S*\Z)|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})).?\Z)/i, if: :address_present?

  private
    def name_present?
      name.present?
    end

    def address_present?
      address.present?
    end

    def ensure_unique_name_within_block
      if block.urlsets.select { |urlset| urlset.name == self.name && urlset != self }.any?
        errors.add(:name, 'has already been taken within this block')
      end
    end

    def ensure_unique_address_within_block
      if block.urlsets.select { |urlset| urlset.address == self.address && urlset != self }.any?
        errors.add(:address, 'has already been taken within this block')
      end
    end
end
