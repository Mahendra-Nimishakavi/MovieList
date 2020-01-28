//
//  MovieSearchViewModelTests.swift
//  MovieListTests
//
//  Created by mn669704 on 25/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import XCTest

 let validSearchString = "TestString"
 let invalidSearchString = "InvalidSearchString"

class MovieSearchViewModelTests: XCTestCase {

    var movieSearchViewModel : MovieSearchViewModel!
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.movieSearchViewModel = MovieSearchViewModel(movieService: MockMovieService(),dataStore: MovieDataStore())

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.movieSearchViewModel = nil
    }

}

extension MovieSearchViewModelTests {
    
    func testMovieSearch() {
        
        let expectation = XCTestExpectation(description: "Movie Search Completion")
        XCTAssertNoThrow(try self.movieSearchViewModel.searchMovies(validSearchString, completion: {
            completed,error in
            
            XCTAssertTrue(completed,"Expected a succesful movie search but got error \(String(describing: error))")
            expectation.fulfill()
        }), "Did not expect an exception but got one")
        
        self.wait(for: [expectation], timeout: 1.0)
    }
    
    func testInvalidSearch() {
        let expectation = XCTestExpectation(description: "Movie Search Completion")
        XCTAssertNoThrow(try self.movieSearchViewModel.searchMovies(invalidSearchString, completion: {
            completed,error in
            
            XCTAssertFalse(completed,"Expected error but got results")
            //XCTAssertEqual(error == ParsingError.JSONParseError,"Expected a parse error but got \(error)")
            expectation.fulfill()
        }),"Did not expect an exception but got one")
        
        self.wait(for: [expectation], timeout: 1.0)
    }
    
    func testNumberOfRows() {
        self.movieSearchViewModel.movies = MockMovieService().getMovies()
        let count = self.movieSearchViewModel.numberOfRows(for: 0)
        XCTAssertTrue(count == 7,"Expected count to be 7 but got \(count)")
    }
    
    func testNumberOfSections() {
        let sections = self.movieSearchViewModel.numberOfSections()
        XCTAssertTrue(sections == 1,"Expected sections to be 0 but got \(sections)")
    }
    
    func testSectionTitle() {
        let title = self.movieSearchViewModel.sectionTitle(section: 0)
        XCTAssertEqual(title, "Movies","Failure to get Movies as title")
    }
    
    func testSelectedCellData() {
        self.movieSearchViewModel.movies = MockMovieService().getMovies()
        let movie = self.movieSearchViewModel.getMovieForSelectedCell(indexPath: IndexPath(row: 2, section: 0))
        XCTAssertEqual(movie?.title,"Test2Title")
    }
    
    
    
}

//Mock Service to give some Movie Data
class MockMovieService : MovieServiceProtocol {
    
    func searchMovies(searchString: String, completion: @escaping ([Movie]?, Error?) -> Void) {
        
        if searchString == validSearchString {
            completion(getMovies(),nil)
        }
        else if searchString == invalidSearchString {
            completion(nil,ParsingError.JSONParseError)
        }
        
    }
    
    
    func getMovies()->[Movie] {
        var movies : [Movie] = []
        for i in 0...6 {
            let prefix = "Test" + String(i)
            let movie = Movie(id: "1234", title: prefix+"Title", posterPath: prefix+"Path", overView: prefix+"OverView of the Movie", thumbNail: nil)
            movies.append(movie)
        }
        
        return movies
    }
    
}
