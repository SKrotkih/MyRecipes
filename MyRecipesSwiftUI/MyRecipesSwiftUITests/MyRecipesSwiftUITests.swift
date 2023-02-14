//
//  MyRecipesSwiftUITests.swift
//  MyRecipesSwiftUITests
//
//  Created by Sergey Krotkih on 25.03.2023.
//

import XCTest
@testable import MyRecipesSwiftUI
import ViewInspector

final class MyRecipesSwiftUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testContentView() throws {
        let viewModel = RecipesFakeData()
        let contentView = RecipesContentView(viewModel: viewModel)
        XCTAssertEqual(viewModel.count, 0, "View model datasource initial value is wrong")
        let button = try contentView.inspect().find(button: "Add")
        try button.tap()
        XCTAssertEqual(viewModel.count, 1, "View model data is not addable")
        
    }
    
    @MainActor func testFakeData() throws {
        let dataSourse = RecipesFakeData()
        let cancellable = dataSourse
            .$dataSource
            .dropFirst()
            .sink { recipes in
                XCTAssertEqual(recipes.count, 1, "View model data is not addable")
        }
        dataSourse.add()
        cancellable.cancel()
    }
}
