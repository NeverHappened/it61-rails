require 'spec_helper'

describe Company::MembershipRequest do
  describe '#approve!' do
    it 'sets approved to true and saves it' do
      membership_request = create(:membership_request)

      expect { membership_request.approve! }.to change { membership_request.reload.approved }.from(false).to(true)
    end

    it 'creates company member' do
      membership_request = build_stubbed(:membership_request)

      expect { membership_request.approve! }.to change(Company::Member, :count).by(1)
    end
  end
end
