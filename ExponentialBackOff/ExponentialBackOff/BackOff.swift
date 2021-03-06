//
//  BackOff.swift
//  Walk
//
//  Created by Koray Koska on 03/03/16.
//  Copyright © 2016 KW Technologies. All rights reserved.
//

import Foundation

/**
 BackOff protocol which is used to run the code.
 */
public protocol BackOff {

	/**
	 Populate this method with your code which should be run
	 repeatedly until it succeeds or until `MaxElapsedTimeMillis` exceeds

	 completion
	 ---

	 If you implement this protocol you must make sure to call `completion(success:)` in order for the ExponentialBackOff to work properly.

	 This must be done like this because most likely you want to call Networking functions which are mostly called asynchronously with passing a closure as the _result action_.

	 Because you can't know what is happening while this asynchronous task, you should make sure to implement `completion(result:)` into the _result closure_.

	 For example with Reachability it could look a little bit like this:

	 ```
	 reachability.whenReachable = { reachability in
	 if reachability.isReachableViaWiFi() {
	 completion(success: true)

	 // Alamofire.request...
	 // ...
	 }

	 reachability.whenUnreachable = { reachability in
	 completion(success: false)
	 }
	 ```

	 With `completion(success:)` ExponentialBackOff knows whether it should run another attempt or not. If you don't implement this, the BackOff won't work.

	 - parameter lastIntervallMillis: You can read this Variable if you want to know how long the Executor waited before running this attempt (in milliseconds)
	 - parameter elapsedTimeMillis: The total time waited already. If this exceeds `maxElapsedTimeMillis` the algorithm stops executing.
	 - parameter completion: Call after your code finished executing and you know the result
	 */
	func run(_ lastIntervallMillis: Int, elapsedTimeMillis: Int, completion: @escaping (_ success: Bool) -> BackOffState) -> Void
}

public struct BackOffProperties {

	/**
	 The default initial interval value in milliseconds (0.5 seconds).
	 */
	public static let DEFAULT_INITIAL_INTERVAL_MILLIS: Int = 500

	/**
	 The default maximum elapsed time after which the BackOff stops executing in milliseconds (15 minutes).
	 */
	public static let DEFAULT_MAX_ELAPSED_TIME_MILLIS: Int = 900000

	/**
	 The default maximum back off time in milliseconds (1 minute).

	 Once the current interval reaches this value it stops increasing.
	 */
	public static let DEFAULT_MAX_INTERVAL_MILLIS: Int = 60000

	/**
	 The default multiplier value (1.5 which is 50% increase per back off).
	 */
	public static let DEFAULT_MULTIPLIER: Double = 1.5

	/**
	 The default randomization factor (0.5 which results in a random period ranging between 50% below and 50% above the retry interval).
	 */
	public static let DEFAULT_RANDOMIZATION_FACTOR: Double = 0.5
}
