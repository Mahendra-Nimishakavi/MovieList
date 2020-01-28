//
//  MovieSearchVCUITests.swift
//  MovieListUITests
//
//  Created by mn669704 on 26/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import XCTest

class MovieSearchVCUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        //XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launchArguments.append("--uitesting")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testValidSearchString() {
        app.launch()
        app.searchFields.element.tap()
        app.searchFields.element.typeText("IronMan")
        app.keyboards.buttons["Search"].tap()
        
        let expectation = XCTestExpectation(description: "SearchData")
        
        let verticalScroll = app.collectionViews.element
        verticalScroll.swipeUp()
        verticalScroll.swipeUp()
        
        expectation.fulfill()
        self.wait(for: [expectation], timeout: 5)

    }
    
    func testInvalidSearchString() {
        app.launch()
        app.searchFields.element.tap()
        app.searchFields.element.typeText("#$#$%")
        app.keyboards.buttons["Search"].tap()
        
        let expectation = XCTestExpectation(description: "InvalidSearchData")
        
        let alert = app.alerts.element
        XCTAssertTrue(alert.exists)
        
        let errorMessage = "Search String Contains Special Characters"
        XCTAssert(app.alerts.element.staticTexts[errorMessage].exists)
        
        expectation.fulfill()
        self.wait(for: [expectation], timeout: 1)
    }

    func testDetailsPageNavigation(){
        app.launch()
        app.searchFields.element.tap()
        app.searchFields.element.typeText("IronMan")
        app.keyboards.buttons["Search"].tap()
        
        let verticalScroll = app.collectionViews.element
        verticalScroll.swipeUp()
        verticalScroll.swipeUp()
        
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
             firstChild.tap()
        }
        
        let movieDetailsView = app.otherElements["MovieDetails"]
        let movieDetailsShown = movieDetailsView.waitForExistence(timeout: 3)
        
        XCTAssert(movieDetailsShown)
    }
    
    
}
