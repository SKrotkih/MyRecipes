//
//  RecipesViewModelTests.swift
//  MyRecipesTests
//
//  Created by Sergey Krotkih on 23.03.2023.
//

import XCTest
@testable import MyRecipes

final class RecipesViewModelTests: XCTestCase {

    var mainViewController: RecipesViewController?
    var viewModel: RecipesListDataSource?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainViewController = storyboard.instantiateInitialViewController() as? RecipesViewController
        viewModel = mainViewController?.viewModel
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testRecipesViewModel() throws {
        XCTAssertNotNil(viewModel, "View model of the Main view controller is not defined")
        guard let viewModel = viewModel else {
            return
        }
        XCTAssertEqual(viewModel.count, 0, "Recipes fake data procedure generates wrong data amount: \(viewModel.count) instead of 0")
        var counter = 0
        let cancellable = viewModel.isDataUpdated
            .sink {
                counter += 1
            }
        viewModel.add()
        viewModel.add()
        viewModel.add()
        XCTAssertEqual(viewModel.count, counter, "Recipes fake data procedure generates wrong data amount: \(viewModel.count) instead of \(counter)")
        cancellable.cancel()
    }
    
    func testRecipesDataSource() throws {
        XCTAssertNotNil(mainViewController, "Main view controller is not loaded")
        XCTAssertNotNil(viewModel, "View model of the Main view controller is not defined")
        guard let viewModel = viewModel else {
            return
        }
        viewModel.add()
        XCTAssertEqual(viewModel.count, 1, "Recipes fake data procedure generates wrong data amount: \(viewModel.count) instead of 1")
        XCTAssertNotNil(UIImage(named: viewModel[0]?.imageID ?? ""), "Random recipe data item does not contain any image")
        let title = viewModel[0]?.title ?? ""
        XCTAssert(title.isEmpty == false, "Random recipe data item does not contain title")
        let description = viewModel[0]?.description ?? ""
        XCTAssert(description.isEmpty == false, "Random recipe data item does not contain description")
        viewModel.add()
        XCTAssertEqual(viewModel.count, 2, "Recipes fake data procedure generates wrong data amount: \(viewModel.count) instead of 2")
        if (viewModel[0]?.title ?? "") == (viewModel[1]?.title ?? "") {
            viewModel.add()
            XCTAssertEqual(viewModel.count, 3, "Recipes fake data procedure generates wrong data amount: \(viewModel.count) instead of 3")
            XCTAssert((viewModel[0]?.title ?? "") != (viewModel[2]?.title ?? ""), "Two random recipe data items contain same recipes")
        } else {
            XCTAssert((viewModel[0]?.title ?? "") != (viewModel[1]?.title ?? ""), "Two random recipe data items contain same recipes")
        }
    }
}
