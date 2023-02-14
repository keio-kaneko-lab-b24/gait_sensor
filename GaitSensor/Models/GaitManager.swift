import SwiftUI
import CoreMotion
import CoreData

struct GaitManager {
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
        let deviceId: String = devideId()
        gait.exam_id = Int32(examId)
        gait.exam_type_id = Int32(examTypeId)
        gait.start_unixtime = Int64(startUnixtime)
        gait.end_unixtime = Int64(endUnixtime)
        gait.gait_distance = Double(truncating: pedometer.distance ?? 0)
        gait.gait_steps = Int32(truncating: pedometer.numberOfSteps)
        gait.gait_stride = Double(truncating: pedometer.distance ?? 0) / Double(truncating: pedometer.numberOfSteps)
        gait.gait_speed = Double(truncating: pedometer.distance ?? 0) / (Double(endUnixtime - startUnixtime) / 1000)
        gait.gait_period = Int32(endUnixtime - startUnixtime)
        gait.gait_energy = calcEnergy(speed: gait.gait_speed, weight: Double(weight) ?? 0, hour: Double(gait.gait_period) / (1000 * 3600))
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
        motionSensor.unixtime = Int64(unixtime())
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
     直近のGaitとMotionSensorを削除する
     */
    func deleteLast(
        gaits: FetchedResults<Gait>, motionSensors: FetchedResults<MotionSensor>,
        context: NSManagedObjectContext
    ) {
        let lastExamId = getLastExamId(gaits: gaits, motionSensors: motionSensors)
        deleteGait(gaits: gaits, examId: lastExamId, context: context)
        deleteMotionSensor(motionSensors: motionSensors, examId: lastExamId, context: context)
    }

    /*
     Gaitの削除
     */
    func deleteGait(
        gaits: FetchedResults<Gait>,
        examId: Int, context: NSManagedObjectContext
    ) {
        for gait in gaits {
            if (gait.exam_id == examId) {
                context.delete(gait)
            }
        }
        try? context.save()
    }

    /*
     MotionSensorの削除
     */
    func deleteMotionSensor(
        motionSensors: FetchedResults<MotionSensor>,
        examId: Int, context: NSManagedObjectContext
    ) {
        for motionSensor in motionSensors {
            if (motionSensor.exam_id == examId) {
                context.delete(motionSensor)
            }
        }
        try? context.save()
    }

    /*
     最新のExamIdを取得
     */
    func getLastExamId(gaits: FetchedResults<Gait>, motionSensors: FetchedResults<MotionSensor>) -> Int {
        return Int(max(gaits.last?.exam_id ?? -1,
            motionSensors.last?.exam_id ?? -1))
    }
    
    /*
     GaitをCSV形式へ変換
     */
    func gaitToCsv(gaits: FetchedResults<Gait>) -> String {
        var text = "exam_id,exam_type_id,start_unixtime,end_unixtime,gait_distance,gait_steps,gait_stride,gait_speed,gait_period,gait_energy,user_id,user_device_id,user_age,user_height,user_weight\n"
        for gait in gaits {
            text += "\(gait.exam_id),\(gait.exam_type_id),\(gait.start_unixtime),\(gait.end_unixtime),"
            text += "\(gait.gait_distance),\(gait.gait_steps),\(gait.gait_stride),\(gait.gait_speed),\(gait.gait_period),\(gait.gait_energy),"
            text += "\(String(describing: gait.user_id)),\(String(describing: gait.user_device_id)),\(gait.user_age),\(gait.user_height),\(gait.user_weight)"
            text += "\n"
        }
        return text
    }
    
    /*
     MotionSensorをCSV形式へ変換
     */
    func motionSensorToCsv(motionSensors: FetchedResults<MotionSensor>) -> String {
        var text = "exam_id,unixtime,acceleration_x,acceleration_y,acceleration_z,rotation_x,rotation_y,rotation_z,gravity_x,rotation_y,rotation_z,pitch,yaw,roll\n"
        for sensor in motionSensors {
            text += "\(sensor.exam_id),\(sensor.unixtime),"
            text += "\(sensor.acceleration_x),\(sensor.acceleration_y),\(sensor.acceleration_z),"
            text += "\(sensor.rotation_x),\(sensor.rotation_y),\(sensor.rotation_z),"
            text += "\(sensor.gravity_x),\(sensor.gravity_y),\(sensor.gravity_z),"
            text += "\(sensor.pitch),\(sensor.yaw),\(sensor.roll)"
            text += "\n"
        }
        return text
    }
}
