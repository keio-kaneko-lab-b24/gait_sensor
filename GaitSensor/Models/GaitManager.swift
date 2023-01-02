import SwiftUI
import CoreMotion
import CoreData

class GaitManager: NSObject {
    @AppStorage(wrappedValue: "0",  "age") private var age: String
    @AppStorage(wrappedValue: "0.0",  "height") private var height: String
    @AppStorage(wrappedValue: "0.0",  "weight") private var weight: String
    
    /*
     Gaitの追加
     */
    func saveGait(
        pedometer: CMPedometerData, examId: Int, examTypeId: Int,
        startUnixtime: Int, endUnixtime: Int,
        userId: String,
        context: NSManagedObjectContext
    ) -> Gait {
        let gait = Gait(context: context)
        let deviceId: String = UIDevice.current.identifierForVendor!.uuidString
        gait.exam_id = Int32(examId)
        gait.exam_type_id = Int32(examTypeId)
        gait.start_unixtime = Int32(startUnixtime)
        gait.end_unixtime = Int32(endUnixtime)
        gait.gait_distance = Double(truncating: pedometer.distance ?? 0)
        gait.gait_steps = Int32(truncating: pedometer.numberOfSteps)
        gait.gait_stride = Double(truncating: pedometer.distance ?? 0) / Double(truncating: pedometer.numberOfSteps)
        gait.gait_speed = Double(truncating: pedometer.distance ?? 0) / Double(endUnixtime - startUnixtime)
        gait.gait_period = Int32(endUnixtime - startUnixtime)
        gait.gait_energy = calcEnergy()
        gait.user_id = userId
        gait.user_device_id = deviceId
        gait.user_age = Int32(age) ?? 0
        gait.user_height = Double(height) ?? 0
        gait.user_weight = Double(weight) ?? 0
        try? context.save()
        return gait
    }
    
    /*
     MotionSensorの追加
     */
    func saveMotionSensor(motion: CMDeviceMotion, examId: Int, context: NSManagedObjectContext) -> MotionSensor {
        let motionSensor = MotionSensor(context: context)
        motionSensor.exam_id = Int32(examId)
        motionSensor.unixtime = Int32(unixtime())
        motionSensor.acceleration_x = motion.userAcceleration.x
        motionSensor.acceleration_y = motion.userAcceleration.y
        motionSensor.acceleration_z = motion.userAcceleration.z
        motionSensor.rotation_x = motion.rotationRate.x
        motionSensor.rotation_y = motion.rotationRate.y
        motionSensor.rotation_z = motion.rotationRate.z
        motionSensor.gravity_x = motion.gravity.x
        motionSensor.gravity_y = motion.gravity.y
        motionSensor.gravity_z = motion.gravity.z
        motionSensor.pitch = motion.attitude.pitch
        motionSensor.yaw = motion.attitude.yaw
        motionSensor.roll = motion.attitude.roll
        try? context.save()
        return motionSensor
    }
    
    /*
     カロリーの計算
     */
    private func calcEnergy() -> Double {
        return 0
    }
}
