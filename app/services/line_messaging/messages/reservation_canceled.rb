module LineMessaging
  module Messages
    class ReservationCanceled
      def self.build(reservation)
        <<~TEXT
          ❌【VeggiePick 予約キャンセルのお知らせ】

          ご予約のキャンセルを受け付けました。

          ■ 体験内容
          #{reservation.harvest_experience.title}

          ■ 開催日時
          #{reservation.reserved_at&.strftime('%Y年%m月%d日 %H:%M')}

          ■ 人数
          #{reservation.number_of_people}名

          またのご利用をお待ちしております🌱
        TEXT
      end
    end
  end
end