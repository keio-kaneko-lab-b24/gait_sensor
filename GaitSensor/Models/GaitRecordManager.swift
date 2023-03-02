import SwiftUI
import CoreMotion
import CoreData

class GaitRecordManager: NSObject, ObservableObject {
    let motionManager = CMMotionManager()
    let pedometerManager = CMPedometer()
    let queue = OperationQueue()
    var gaitCount: Int = 0
    var motionSensorCount: Int = 0
    
    var gaitManager = GaitManager()
    @Published var gait: Gait? = nil
    @Published var motionSensor: MotionSensor? = nil
    
    var startUnixtime: Int = 0
    @Published var isStarted: Bool = false
    
    
    /*
     センサー取得開始処理
     */
    func start(
        userId: String, examId: Int, examTypeId: Int,
        motionInterval: Double, context: NSManagedObjectContext,
        resetData: Bool = true
    ) {
        if (isStarted) {
            return
        }
        if (resetData) {
            gait = nil
        }
        startUnixtime = unixtime()
        
        // モーションデータのListen開始
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = motionInterval
            motionManager.startDeviceMotionUpdates(to: self.queue){
                (data: CMDeviceMotion?, error: Error?) in
                if (error == nil && data != nil) {
                    var motionSensor: MotionSensor? = nil
                    // 1万回以上（10Hzで1000秒）稼働している場合はセンサーの取得を停止する
                    if (self.motionSensorCount < 10000) {
                        context.performAndWait {
                            motionSensor = self.gaitManager.saveMotionSensor(
                                motion: data!, examId: examId, context: context)
                        }
                        self.motionSensorCount += 1
                    }
                    // Published変数なのでmainスレッドで変更する必要あり
                    DispatchQueue.main.async {
                        self.motionSensor = motionSensor
                    }
                }
            }
        }
        // PedometerデータのListen開始
        if (CMPedometer.isStepCountingAvailable()) {
            pedometerManager.startUpdates(from: NSDate() as Date) {
                (data: CMPedometerData?, error: Error?) in
                if (error == nil && data != nil) {
                    var gait: Gait? = nil
                    context.performAndWait {
                        gait = self.gaitManager.saveGait(
                            pedometer: data!, examId: examId, examTypeId: examTypeId,
                            startUnixtime: self.startUnixtime, endUnixtime: unixtime(), userId: userId,
                            context: context)
                    }
                    // Published変数なのでmainスレッドで変更する必要あり
                    DispatchQueue.main.async {
                        self.gait = gait
                    }
                    self.gaitCount += 1
                    print("gait is updated. \(gait?.end_unixtime ?? 0)")
                }
            }
        }
        isStarted = true
    }
    
    /*
     センサー取得終了処理
     */
    func stop() {
        if (!isStarted) {
            return
        }
        motionManager.stopDeviceMotionUpdates()
        pedometerManager.stopUpdates()
        isStarted = false
    }
    
    /*
     DB上の直近のGait,MotionSensorの削除削除
     */
    func delete(
        gaits: FetchedResults<Gait>, motionSensors: FetchedResults<MotionSensor>,
        context: NSManagedObjectContext
    ) {
        if (isStarted) {
            return
        }
        gaitManager.deleteLast(gaits: gaits, motionSensors: motionSensors, context: context)
        gait = nil
    }
}
