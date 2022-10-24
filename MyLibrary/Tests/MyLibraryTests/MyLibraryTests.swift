import XCTest
@testable import MyLibrary

let testJSON1 = """
{
    "main": {
        "temp": 71,
        "other_stuff": "blah"
    }
}
"""

let testJSON2 = """
{
    "not_main": {
        "temp": 71
    }
}
"""

let testJSON3 = """
{
    "main": {
        "not_temp": 71
    }
}
"""

let testJSON4 = """
{
    "not_main": {
        "temp": 
    }
}
"""

final class MyLibraryTests: XCTestCase {
    func testIsLuckyBecauseWeAlreadyHaveLuckyNumber() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(8)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsLuckyBecauseWeatherHasAnEight() async throws {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: true
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(0)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsNotLucky() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(7)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == false)
    }

    func testIsNotLuckyBecauseServiceCallFails() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: false,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(7)

        // Then
        XCTAssertNil(isLuckyNumber)
    }

    func testLoadsTestJson1() {
        // Given
        let jsonData = Data(testJSON1.utf8)
        let decoder = JSONDecoder()

        // When
        let weather = try? decoder.decode(Weather.self, from: jsonData)

        // Then
        XCTAssertNotNil(weather)
        XCTAssertNotNil(weather?.main)
        XCTAssertNotNil(weather?.main.temp)
        XCTAssert(weather?.main.temp == 71)
    }

    func testLoadsTestJson2() {
        // Given
        let jsonData = Data(testJSON2.utf8)
        let decoder = JSONDecoder()

        // When
        let weather = try? decoder.decode(Weather.self, from: jsonData)

        // Then
        XCTAssertNil(weather)
    }

    func testLoadsTestJson3() {
        // Given
        let jsonData = Data(testJSON3.utf8)
        let decoder = JSONDecoder()

        // When
        let weather = try? decoder.decode(Weather.self, from: jsonData)

        // Then
        XCTAssertNil(weather)
    }

    func testLoadsTestJson4() {
        // Given
        let jsonData = Data(testJSON4.utf8)
        let decoder = JSONDecoder()

        // When
        let weather = try? decoder.decode(Weather.self, from: jsonData)

        // Then
        XCTAssertNil(weather)
    }

    // Integration test
    func testGetTemperature() async throws {
        // Given
        let weatherService = WeatherServiceImpl(endpoint: Endpoint.mockAPI)

        // When
        let expectedTemp = try await weatherService.getTemperature()
        
        // Then
        XCTAssertNotNil(expectedTemp)
        XCTAssert(expectedTemp == 287.23)
    }
}
