class ApplicationController < ActionController::API

  class IStoxError < StandardError
  end

  rescue_from IStoxError do |exception|
    render json: { error: exception}, status: :bad_request
  end

  def reset
    set_amount(1, 10000)
    set_amount(2, 10000)

    render json: { msg: "reset"}
  end

  def transfer
    exec_transfer(transfer_params)

    render json: { msg: "transfer"}
  end

  def get_amounts
    puts user1 = get_amount(1)
    puts user2 = get_amount(2)
    render json: { user1: user1, user2: user2}
  end

  private

  def transfer_params
    unless params[:transfer_from] && params[:transfer_to] && params[:amount]
      raise IStoxError.new "Missing required params"
    end

    if params[:transfer_from] == params[:transfer_to]
      raise IStoxError.new "Can't transfer to the same user"
    end

    if params[:amount].to_f <= 0
      raise IStoxError.new "Amount can't lower or equal to zero"
    end

    {
      transfer_from: params[:transfer_from].to_i,
      transfer_to: params[:transfer_to].to_i,
      amount: params[:amount].to_f
    }
  end

  def exec_transfer(transfer_from:, transfer_to:, amount:)
    balance = get_amount(transfer_from)
    if balance < amount
      raise IStoxError.new "Balance insufficient on user #{ transfer_from }"
    end

    set_amount(transfer_from, balance - amount)
    set_amount(transfer_to, get_amount(transfer_to) + amount)
  end

  def get_amount(user)
    File.read("user#{user}.txt").to_f
  end

  def set_amount(user, amount)
    File.write("user#{user}.txt", amount)
  end
end
