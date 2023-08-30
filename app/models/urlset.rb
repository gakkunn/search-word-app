class Urlset < ApplicationRecord
  belongs_to :block

  # nameとaddressの両方が存在するまたは存在しない場合にのみバリデーションを適用
  validates :name, presence: { if: :address_present? }
  validates :address, presence: { if: :name_present? }
  
  validate :ensure_unique_name_within_block
  validate :ensure_unique_address_within_block

  validates :address, format: /\A#{URI::regexp(%w(http https))}\z/


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
