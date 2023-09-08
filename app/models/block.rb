class Block < ApplicationRecord
    belongs_to :user
    has_many :urlsets, dependent: :destroy
    validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
    validates :user_id, presence: true

    accepts_nested_attributes_for :urlsets,
                                  reject_if: :all_blank, 
                                  allow_destroy: true

    # 最低1セットのURLを持っているかを確認するカスタムバリデーション
    validate :at_least_one_urlset

    #最大20個までのUrlSetを持つ
    MAX_URLSETS_COUNT = 20
    validate :maximum_urlsets

    private

        def at_least_one_urlset
            unless urlsets.any? { |urlset| urlset.name.present? && urlset.address.present? }
                errors.add(:base, "最低1セットのURL名とURLを入力してください")
            end
        end

        def maximum_urlsets
            errors.add(:base, "最大#{MAX_URLSETS_COUNT}セットまでです") if urlsets.size > MAX_URLSETS_COUNT
        end
end
