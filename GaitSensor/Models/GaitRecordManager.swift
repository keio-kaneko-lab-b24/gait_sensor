import CoreMotion
import CoreData

class GaitRecordManager: NSObject, ObservableObject {
    let motionManager = CMMotionManager()
    let pedometerManager = CMPedometer()
    let queue = OperationQueue()
    
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
     センサーの保存処理
     */
    func finish(context: NSManagedObjectContext) {
        if (isStarted) {
            return
        }
        gait = nil
    }
}
