//
//  ClientSetupViewModelTests.swift
//  Baby MonitorTests
//

import XCTest
import RealmSwift
@testable import BabyMonitor

class ClientSetupViewModelTests: XCTestCase {
    
    let cacheServiceMock = CacheServiceMock()
    let clientServiceMock = ClientServiceMock()

    func testShouldStartNetClientDiscoverAfterSelect() {
        // Given
        let exp = expectation(description: "Should find device")
        let netServiceClient = NetServiceClientMock()
        let configuration = URLConfigurationMock()
        let babyRepo = RealmBabiesRepository(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test-realm")))
        let sut = ClientSetupOnboardingViewModel(netServiceClient: netServiceClient, urlConfiguration: configuration, babyRepo: babyRepo, cacheService: cacheServiceMock, clientService: clientServiceMock)
        sut.didFinishDeviceSearch = { _ in exp.fulfill() }

        // When
        sut.startDiscovering()
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertTrue(netServiceClient.didCallFindService)
        }
    }
    
    func testShouldSaveUrlOfFoundDeviceToConfiguration() {
        // Given
        let exp = expectation(description: "Should find device")
        let ip = "ip"
        let port = "port"
        let netServiceClient = NetServiceClientMock(ip: ip, port: port)
        let configuration = URLConfigurationMock()
        let babyRepo = RealmBabiesRepository(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test-realm")))
        let sut = ClientSetupOnboardingViewModel(netServiceClient: netServiceClient, urlConfiguration: configuration, babyRepo: babyRepo, cacheService: cacheServiceMock, clientService: clientServiceMock)
        sut.didFinishDeviceSearch = { _ in exp.fulfill() }
        
        // When
        sut.startDiscovering()
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertNotNil(configuration.url)
            XCTAssertEqual(URL(string: "ws://\(ip):\(port)"), configuration.url)
        }
    }
    
    func testShouldCallDidFindDeviceAfterFindingDevice() {
        // Given
        let exp = expectation(description: "Should find device")
        let netServiceClient = NetServiceClientMock()
        let configuration = URLConfigurationMock()
        let babyRepo = RealmBabiesRepository(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test-realm")))
        let sut = ClientSetupOnboardingViewModel(netServiceClient: netServiceClient, urlConfiguration: configuration, babyRepo: babyRepo, cacheService: cacheServiceMock, clientService: clientServiceMock)
        sut.didFinishDeviceSearch = { _ in exp.fulfill() }
        
        // When
        sut.startDiscovering()
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertNotNil(configuration.url)
        }
    }
    
    func testShouldCallDidStartFindingDeviceAfterSelect() {
        // Given
        let exp = expectation(description: "Should find device")
        let netServiceClient = NetServiceClientMock()
        let configuration = URLConfigurationMock()
        let babyRepo = RealmBabiesRepository(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test-realm")))
        let sut = ClientSetupOnboardingViewModel(netServiceClient: netServiceClient, urlConfiguration: configuration, babyRepo: babyRepo, cacheService: cacheServiceMock, clientService: clientServiceMock)
        sut.didFinishDeviceSearch = { _ in exp.fulfill() }
        
        // When
        sut.startDiscovering()
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertTrue(true)
        }
    }
    
    func testShouldEndSearchWithFailureAfterGivenTime() {
        // Given
        let exp = expectation(description: "Should find device")
        let netServiceClient = NetServiceClientMock(findServiceDelay: 20.0)
        let configuration = URLConfigurationMock()
        let babyRepo = RealmBabiesRepository(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test-realm")))
        let sut = ClientSetupOnboardingViewModel(netServiceClient: netServiceClient, urlConfiguration: configuration, babyRepo: babyRepo, cacheService: cacheServiceMock, clientService: clientServiceMock)
        sut.didFinishDeviceSearch = { result in
            XCTAssertEqual(result, DeviceSearchResult.failure(.timeout))
            exp.fulfill()
        }
        
        // When
        sut.startDiscovering(withTimeout: 0.1)
        
        // Then
        waitForExpectations(timeout: 0.2) { _ in
            XCTAssertTrue(true)
        }
    }
}
