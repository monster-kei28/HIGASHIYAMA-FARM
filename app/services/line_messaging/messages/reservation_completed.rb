module LineMessaging
  module Messages
    class ReservationCompleted
      def self.build(reservation)
        map_url = "https://www.google.com/maps/search/?api=1&query=35.823528,139.951944"

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

          ───────────────
          📍 アクセス
          西山パークサイド駐車場横が目印です。
          🚗 駐車場は西山パークサイド駐車場に1台分あります。

          ▼農園の場所はこちら
          #{map_url}
          ───────────────

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
