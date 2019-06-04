# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ngo, type: :model do
  describe 'specifications' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:branch).of_type(:boolean) }
    it { is_expected.to have_db_column(:ngo_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'scopes' do
    it { expect(described_class).to respond_to :parent_ngos }
  end

  describe 'branch association' do
    context 'when the branch and parent ngos exist' do
      let(:branch) do
        Ngo.create!(
          name: 'Branch name',
          description: 'Branch description',
          image_url: 'https://image.url',
          branch: true,
          ngo_id: parent.id
        )
      end

      let(:parent) do
        Ngo.create!(
          name: 'parent name',
          description: 'parent description',
          image_url: 'https://image.url',
          branch: false
        )
      end

      describe 'the branch ngo' do
        it 'should access parent using its ID' do
          expect(branch.parent).to eq parent
        end
      end

      describe 'the parent ngo' do
        it 'should access branches' do
          expect(parent.branches).to include branch
        end
      end
    end

    context 'when the parent ngo does not exist' do
      let(:fake_parent_id) { SecureRandom.uuid }

      let(:branch) do
        Ngo.create!(
          name: 'Branch name',
          description: 'Branch description',
          image_url: 'https://image.url',
          branch: true,
          ngo_id: fake_parent_id
        )
      end

      it 'should return nil for parent' do
        expect(branch.parent).to be_nil
      end
    end
  end
end
