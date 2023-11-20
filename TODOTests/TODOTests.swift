//
//  TODOTests.swift
//  TODOTests
//
//  Created by Jasim Uddin on 16/11/2023.
//
//import XCTest
//@testable import TODO
//
//class TodoListViewModelTests: XCTestCase {
//    var viewModel: TodoListViewModel!
//    
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        viewModel = TodoListViewModel()
//    }
//
//    override func tearDownWithError() throws {
//        try super.tearDownWithError()
//    }
//
//    func testFetchData() async throws {
//        // Create an expectation
//        let expectation = XCTestExpectation(description: "Fetch data expectation")
//        
//        // Assume your NetworkManager has a mock or a stub for testing purposes.
//        // You need to set this up or use a mock that returns a predefined result.
//        NetworkManager.shared = MockNetworkingManager()
//        
//        // Perform the async task
//        Task {
//            await viewModel.fetchData()
//            // Fulfill the expectation after the async task completes
//            expectation.fulfill()
//        }
//        
//        // Wait for the expectation to be fulfilled within a certain timeout
//        wait(for: [expectation], timeout: 5) // Adjust the timeout as needed
//       
//        // Assert your expectations or perform any validations here
//        // For example, check if todos array is not empty or contains expected data
//        XCTAssertFalse(viewModel.todos.isEmpty, "Todos should not be empty after fetching")
//        // Add more assertions based on your expected behavior
//    }
//}
