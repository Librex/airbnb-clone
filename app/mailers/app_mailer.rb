class AppMailer < ActionMailer::Base

  def new_reservation(room, reservation)
    @user = User.find(room.user_id)
    @reservation = reservation
    @room = room
    
    mail(from: 'Airbnb <no-reply@airbnb.com>', to: @user.email, subject: "予約を受け付けました！")
     
  end
     
end
