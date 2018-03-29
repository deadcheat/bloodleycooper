import UIKit
import Flutter
import HealthKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // write channel
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let bloodChannel = FlutterMethodChannel.init(name: "bloodley.deadcheat.com/bloodpressure", binaryMessenger: controller)
    
    bloodChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
        if ("post" == call.method) {
            // Type of sample
            let unit  = HKUnit.millimeterOfMercury()
            
            // Date of sample
            let start = Date()
            let end   = start
            let sQuantity = HKQuantity(unit: unit, doubleValue: 120)
            let sType     = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!
            let sSample   = HKQuantitySample(
                type: sType,
                quantity: sQuantity,
                start: start,
                end: end
            )
            let dQuantity = HKQuantity(unit: unit, doubleValue: 80)
            let dType     = HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)!
            let dSample   = HKQuantitySample(
                type: dType,
                quantity: dQuantity,
                start: start,
                end: end
            )
            let objects: Set<HKSample> = [ sSample, dSample ]
            let bpType = HKCorrelationType.correlationType(forIdentifier: .bloodPressure)!
            
            let bloodPressure = HKCorrelation(
                type: bpType,
                start: start,
                end: end,
                objects: objects
            )
            let healthStore = HKHealthStore()
            
            let sAuthorized = healthStore.authorizationStatus(for: sType)
            let dAuthorized = healthStore.authorizationStatus(for: dType)
            
            if sAuthorized == .sharingAuthorized && dAuthorized == .sharingAuthorized {
                healthStore.save(bloodPressure, withCompletion:  { (success, error) in
                    //                result(false)
                })
                result(true)
                
            } else {
                healthStore.requestAuthorization(toShare: [sType, dType], read: [sType, dType], completion: { (success, error) in
                    if success {
                        healthStore.save(bloodPressure, withCompletion:  { (success, error) in
                            //                result(false)
                        })
                    }
                })
                result(true)
            }
        } else {
            result(true)
        }
    });
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
