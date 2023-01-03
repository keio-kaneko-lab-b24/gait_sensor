import SwiftUI

func devideId() -> String {
    return UIDevice.current.identifierForVendor!.uuidString
}


/*
 カロリーの計算
 消費カロリー = METs × 体重(kg) × 時間(h) × 1.05
 METs表：https://www.nibiohn.go.jp/eiken/programs/2011mets.pdf
 <歩行 平らで固い地面>
 ~3.2km/h 2.0
 ~4.0km/h 3.0
 ~5.1km/h 3.5
 ~5.6km/h 4.3
 ~6.4km/h 5.0
 ~7.2km/h 7.0
 ~8.0km/h 8.3
 <ランニング>
 ~8.4km/h 9.0
 ~9.7km/h 9.8
 ~10.8km/h 10.5
 ~11.3km/h 11.0
 ~12.1km/h 11.5
 ~12.9km/h 11.8
 ~13.8km/h 12.3
 ~14.5km/h 12.8
 ~16.1km/h 14.5
 ~17.7km/h 16.0
 ~19.3km/h 19.0
 ~20.9km/h 19.8
 20.9km/h~ 23.0
 */
func calcEnergy(speed: Double, weight: Double, hour: Double) -> Double {
    let speed: Double = (speed * 3600) / 1000
    var mets: Double = 1
    if (speed < 3.2) { mets = 2.0 }
    else if (speed < 4.0) { mets = 3.0 }
    else if (speed < 5.1) { mets = 3.5 }
    else if (speed < 5.6) { mets = 4.3 }
    else if (speed < 6.4) { mets = 5.0 }
    else if (speed < 7.2) { mets = 7.0 }
    else if (speed < 8.0) { mets = 8.3 }
    else if (speed < 8.4) { mets = 9.0 }
    else if (speed < 9.7) { mets = 9.8 }
    else if (speed < 10.8) { mets = 10.5 }
    else if (speed < 11.3) { mets = 11.0 }
    else if (speed < 12.1) { mets = 11.5 }
    else if (speed < 12.9) { mets = 11.8 }
    else if (speed < 13.8) { mets = 12.3 }
    else if (speed < 14.5) { mets = 12.8 }
    else if (speed < 16.1) { mets = 14.5 }
    else if (speed < 17.7) { mets = 16.0 }
    else if (speed < 19.3) { mets = 19.0 }
    else if (speed < 20.9) { mets = 19.8 }
    else if (speed < 20.9) { mets = 23.0 }
    return mets * weight * hour * 1.05
}
