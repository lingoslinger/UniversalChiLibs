//
//  SwiftLibsNoSBUITestsLaunchTests.swift
//  SwiftLibsNoSBUITests
//
//  Created by Allan Evans on 11/5/23.
//  Copyright © 2023 AGE Software Consulting, LLC. All rights reserved.
//

import XCTest

final class SwiftLibsNoSBUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
