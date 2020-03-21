RSpec.describe ApplicationController, type: :controller do
  describe "#reset" do
    subject { get :reset }

    it "returns 200" do
      expect(subject.status).to eq 200
    end
  end

  describe "#transfer" do
    subject { post :transfer, params: params }

    context "when insufficient params" do
      let(:params) {{}}

      it "returns 400" do
        expect(subject.status).to eq 400
      end

      it "returns error message" do
        response = JSON.parse(subject.body)
        expect(response["error"]).to eq "Missing required params"
      end
    end

    context "when transfer from and to are the same" do
      let(:params) do
        {
          transfer_from: 1,
          transfer_to: 1,
          amount: 1000
        }
      end

      it "returns 400" do
        expect(subject.status).to eq 400
      end

      it "returns error message" do
        response = JSON.parse(subject.body)
        expect(response["error"]).to eq "Can't transfer to the same user"
      end
    end

    context "when transfer amount is negative number" do
      let(:params) do
        {
          transfer_from: 1,
          transfer_to: 2,
          amount: -1000
        }
      end

      it "returns 400" do
        expect(subject.status).to eq 400
      end

      it "returns error message" do
        response = JSON.parse(subject.body)
        expect(response["error"]).to eq "Amount can't lower or equal to zero"
      end
    end

    context "when transfer amount is greater than the balance" do
      let(:params) do
        {
          transfer_from: 1,
          transfer_to: 2,
          amount: 100000
        }
      end

      it "returns 400" do
        expect(subject.status).to eq 400
      end

      it "returns error message" do
        response = JSON.parse(subject.body)
        expect(response["error"]).to eq "Balance insufficient on user 1"
      end
    end

    context "when transfer success" do
      let(:params) do
        {
          transfer_from: 1,
          transfer_to: 2,
          amount: 1000
        }
      end

      it "returns error message" do
        subject
        blance_amount = get :get_amounts
        response = JSON.parse(blance_amount.body)
        expect(response["user1"]).to eq 9000
        expect(response["user2"]).to eq 11000
      end
    end

  end

  describe "get_amounts" do
    subject { get :get_amounts }

    it "returns 200" do
      expect(subject.status).to eq 200
    end

    it "returns error message" do
      response = JSON.parse(subject.body)
      expect(response["user1"]).to eq 9000
      expect(response["user2"]).to eq 11000
    end
  end
end
