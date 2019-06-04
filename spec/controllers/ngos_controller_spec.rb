# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NgosController, type: :controller do
  describe 'create' do
    context 'when the input payload is correct' do
      it 'parent NGO' do
        payload = {
          'name' => 'ONU',
          'description' => 'ONU description',
          'image_url' => 'http://image.url',
          'branch' => '0'
        }

        post :create, params: payload

        new_ngo = Ngo.find_by(name: 'ONU')

        expect(response).to have_http_status :redirect
        expect(new_ngo.id).to be_present
        is_expected.to redirect_to "/ngos/#{new_ngo.id}"
      end

      it 'branch NGO' do
        parent_ngo = Ngo.create!(
          'name' => 'Parent NGO',
          'description' => 'Parent NGO description',
          'image_url' => 'http://parent.url',
          'branch' => '0'
        )

        branch_payload = {
          'name' => 'ONU',
          'description' => 'ONU description',
          'image_url' => 'http://image.url',
          'branch' => '1',
          'ngo_id' => parent_ngo.id
        }

        post :create, params: branch_payload

        new_ngo = Ngo.find_by(ngo_id: parent_ngo.id)

        expect(response).to have_http_status :redirect
        expect(new_ngo.parent).to eq parent_ngo
      end
    end

    context 'when the input payload is not correct' do
      it 'parent NGO' do
        payload = {
          'description' => 'ONU description',
          'image_url' => 'http://image.url',
          'branch' => '0'
        }

        post :create, params: payload

        is_expected.to render_template :new
        expect(assigns[:errors]).to be_a ActiveModel::Errors
        expect(assigns[:errors][:name]).to include "can't be blank"
      end

      it 'branch NGO' do
        payload = {
          'name' => 'ONU',
          'description' => 'ONU description',
          'image_url' => 'http://image.url',
          'branch' => '1',
          'ngo_id' => ''
        }

        post :create, params: payload

        is_expected.to render_template :new
        expect(assigns[:errors]).to be_a ActiveModel::Errors
        expect(assigns[:errors][:ngo_id]).to include "can't be blank"
      end
    end
  end

  describe 'index' do
    it do
      ngo = Ngo.create(
        'name' => 'ONU',
        'description' => 'ONU description',
        'image_url' => 'http://image.url',
        'branch' => '0'
      )

      get :index

      expect(response).to have_http_status :ok
      expect(assigns[:ngos].first.id).to include ngo.id
      expect(assigns[:ngos]).to all(be_a Boundary::Ngo)
    end
  end

  describe 'show' do
    it do
      ngo = Ngo.create(
        'name' => 'ONU',
        'description' => 'ONU description',
        'image_url' => 'http://image.url',
        'branch' => '0'
      )

      get :show, params: { id: ngo.id }

      expect(response).to have_http_status :ok
      expect(assigns[:ngo].id).to eq ngo.id
      expect(assigns[:ngo]).to be_a Boundary::Ngo
    end
  end

  describe 'new' do
    it do
      ngo = Ngo.create(
        'name' => 'ONU',
        'description' => 'ONU description',
        'image_url' => 'http://image.url',
        'branch' => '0'
      )

      get :new

      expect(response).to have_http_status :ok
      expect(assigns[:ngo]).to be_a Boundary::Ngo
      expect(assigns[:parent_ngos].first.id).to eq ngo.id
      expect(assigns[:parent_ngos]).to all(be_a Boundary::Ngo)
    end
  end
end
