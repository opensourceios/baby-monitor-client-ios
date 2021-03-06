//
//  CryingEventServiceTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
@testable import BabyMonitor

class CryingEventServiceTests: XCTestCase {
    
    //Given
    lazy var sut = CryingEventService(cryingDetectionService: cryingDetectionServiceMock,
                                      audioFileService: audioFileServiceMock)
    var cryingDetectionServiceMock = CryingDetectionServiceMock()
    var audioFileServiceMock = AudioFileServiceMock()

    override func setUp() {
        cryingDetectionServiceMock = CryingDetectionServiceMock()
        sut = CryingEventService(cryingDetectionService: cryingDetectionServiceMock,
                                 audioFileService: audioFileServiceMock)
    }

    func testShouldNotifyAboutCryingDetecion() {
        //Given
        let disposeBag = DisposeBag()
        let exp = expectation(description: "Should notify about crying detection")
        sut.cryingEventObservable.subscribe(onNext: { eventMessage in
            exp.fulfill()
        }).disposed(by: disposeBag)

        //When
        cryingDetectionServiceMock.notifyAboutCryingDetection(isBabyCrying: true)

        //Then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testShouldNotNotifyAboutStoppedCryingDetecionEvent() {
        //Given
        let disposeBag = DisposeBag()
        let exp = expectation(description: "Should not notify about stopped crying detection")
        sut.cryingEventObservable.subscribe(onNext: { _ in
            exp.fulfill()
        }).disposed(by: disposeBag)

        //When
        cryingDetectionServiceMock.notifyAboutCryingDetection(isBabyCrying: false)

        //Then
        let result = XCTWaiter.wait(for: [exp], timeout: 2.0)
        XCTAssertTrue(result == .timedOut)
    }
}
