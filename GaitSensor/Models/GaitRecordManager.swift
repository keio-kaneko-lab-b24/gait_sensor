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
    
    var startUnixtime: Int = 0
    @Published var isStarted: Bool = false
    
    
    /*
     センサー取得開始処理
     */
    func start(
        userId: String, examId: Int, examTypeId: Int,
        motionInterval: Double, context: NSManagedObjectContext
    ) {
        if (isStarted) {
            return
        }
        gait = nil
        startUnixtime = unixtime()
        
        // モーションデータのListen開始
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = motionInterval
            motionManager.startDeviceMotionUpdates(to: self.queue){
                (data: CMDeviceMotion?, error: Error?) in
                if (error == nil) {
                    // 5分以上稼働している場合はセンサーの取得を停止する
                    if (unixtime() - self.startUnixtime <= 300) {
                        let _ = self.gaitManager.saveMotionSensor(
                            motion: data!, examId: examId, context: context)
                        self.motionSensorCount += 1
                    }
                }
            }
        }
        // PedometerデータのListen開始
        if (CMPedometer.isStepCountingAvailable()) {
            pedometerManager.startUpdates(from: NSDate() as Date) {
                (data: CMPedometerData?, error: Error?) in
                if (error == nil) {
                    let gait = self.gaitManager.saveGait(
                        pedometer: data!, examId: examId, examTypeId: examTypeId,
                        startUnixtime: self.startUnixtime, endUnixtime: unixtime(), userId: userId,
                        context: context)
                    self.gait = gait
                    self.gaitCount += 1
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
