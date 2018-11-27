//
//  ohMyPostUITests.swift
//  ohMyPostUITests
//
//  Created by Daniel Mendez on 11/12/18.
//  Copyright © 2018 nieldm. All rights reserved.
//

import XCTest

class ohMyPostUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }

    func test_showPostView() {
        app.launch()
        
        XCTAssertTrue(app.isShowingResourceView)
    }
    
    func test_showPostToPostDetailView() {
        app.launch()
        
        XCTAssertTrue(app.isShowingResourceView)

        let table = app.postsTableView
        let cell = table.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: cell, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        cell.tap()
        
        XCTAssertTrue(app.isShowingPostDetailView)
    }

}

extension XCUIApplication {
    var isShowingResourceView: Bool {
        return otherElements["moviesView"].exists
    }
    
    var isShowingPostDetailView: Bool {
        return otherElements["postDetailView"].exists
    }
    
    var postsTableView: XCUIElement {
        return tables["postsTableView"]
    }
}
