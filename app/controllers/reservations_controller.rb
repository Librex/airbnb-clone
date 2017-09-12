class ReservationsController < ApplicationController
  before_action :authenticate_user! 

  def preload
    room = Room.find(params[:room_id])
    today = Date.today
    reservations = room.reservations.where("start_date >= ? OR end_date >= ?", today, today)

    render json: reservations
  end

  def preview
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    output = {
      conflict: is_conflict(start_date, end_date)
    }

    render json: output
  end

  def create
    @reservation = current_user.reservations.create(reservation_params)
     
    if @reservation.persisted?
      @payment = Payment.new({ email: User.find(@reservation.user_id).email, token: params[:payment]["token"], reservation_id: @reservation.id, amount: @reservation.total })
      
      begin
      @payment.process_payment
      
      if @payment.save
        AppMailer.new_reservation(Room.find(@reservation.room_id), @reservation).deliver_now
        redirect_to @reservation.room, notice: "予約を承りました。"
      end
                    
      rescue Exception  
    
      @reservation.destroy
     
      puts '支払い処理に失敗しました。'
    
      redirect_to @reservation.room, notice: "支払いが拒否されました。"
    end
     
    else
      redirect_to @reservation.room, notice: "あなたの予約は失敗しました"
    end
  end

  def your_trips
    @trips = current_user.reservations
  end

  def your_reservations
    @rooms = current_user.rooms
  end
     
  private
    def reservation_params         
      params.require(:reservation).permit(:start_date, :end_date, :price, :total, :room_id, :payment)     
    end

    def is_conflict(start_date, end_date)
      room = Room.find(params[:room_id])
      check = room.reservations.where("? < start_date AND end_date < ?", start_date, end_date)
      check.size > 0 ? true : false
    end

end
