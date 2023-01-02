import SwiftUI
import CoreData
import Foundation


func unixtime() -> Int {
    return Int(NSDate().timeIntervalSince1970)
}

struct Gait2Manager {
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
}
