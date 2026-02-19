module LineMessaging
  module Messages
    class ReservationCompleted
      def self.build(reservation)
        <<~TEXT
          🌱【VeggiePick 予約完了のお知らせ】

          ご予約ありがとうございます！
          下記内容で受付いたしました。

          ■ 体験内容
          #{reservation.harvest_experience.title}

          ■ 開催日時
          #{reservation.reserved_at&.strftime('%Y年%m月%d日 %H:%M')}

          ■ 人数
          #{reservation.number_of_people}名

          当日は開始5分前までにお越しください。
          汚れても良い服装でのご参加をおすすめします。

          変更・キャンセルがある場合は、
          このLINEからご連絡ください。

          当日お会いできるのを楽しみにしております🌞
          TEXT
      end
    end
  end
end