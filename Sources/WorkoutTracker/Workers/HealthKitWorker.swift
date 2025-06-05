//
//  File.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/05.
//

import HealthKit

enum HealthKitWorkerError: Error {
	case healthkitUnavailable
	case otherHealthKitError(error: Error)
}

class HealthKitWorker: @unchecked Sendable {
	init() {}
	
	private var healthStore = HKHealthStore()
	private var currentWorkoutBuilder: HKWorkoutBuilder? = nil
	
	func requestAuthorisation() async throws {
		guard HKHealthStore.isHealthDataAvailable() else {
			throw HealthKitWorkerError.healthkitUnavailable
		}
		let typesToShare: Set = [
			HKQuantityType.workoutType()
		]


		// The quantity types to read from the health store.
		let typesToRead: Set = [
			HKQuantityType.quantityType(forIdentifier: .heartRate)!,
			HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
			HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
		]
		try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<Void, Error>) in
			healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
				if let error = error {
					continuation.resume(throwing: HealthKitWorkerError.otherHealthKitError(error: error))
				} else {
					continuation.resume()
				}
			}
		})
	}
	func startSession() async throws {
		let configuration = HKWorkoutConfiguration()
		configuration.activityType = .running
		configuration.locationType = .outdoor
		currentWorkoutBuilder = HKWorkoutBuilder(healthStore: healthStore,
												 configuration: configuration,
												 device: .local())
		try await withCheckedThrowingContinuation {  (continuation: CheckedContinuation<Void, Error>) in
			currentWorkoutBuilder?.beginCollection(withStart: Date()) { success, error in
				if let error = error {
					continuation.resume(throwing: HealthKitWorkerError.otherHealthKitError(error: error))
				} else {
					continuation.resume()
				}
			}
		}
	}
	func save(workout: Workout) async throws {
		
	}
	
	func pauseSession() {
		
	}
	
	func stopSession() {
		
	}
}
