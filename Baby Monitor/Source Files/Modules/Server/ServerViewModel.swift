//
//  ServerViewModel.swift
//  Baby Monitor
//

import Foundation
import WebRTC
import RxSwift

final class ServerViewModel {
    
    private let webRtcServerManager: WebRtcServerManager
    private let messageServer: MessageServerProtocol
    private let netServiceServer: NetServiceServerProtocol
    var didLoadLocalStream: ((RTCMediaStream) -> Void)?
    
    private let bag = DisposeBag()
    
    private let decoders: [AnyMessageDecoder<WebRtcMessage>]
    
    init(webRtcServerManager: WebRtcServerManager, messageServer: MessageServerProtocol, netServiceServer: NetServiceServerProtocol, decoders: [AnyMessageDecoder<WebRtcMessage>]) {
        self.webRtcServerManager = webRtcServerManager
        self.messageServer = messageServer
        self.netServiceServer = netServiceServer
        self.decoders = decoders
        webRtcServerManager.delegate = self
        setup()
    }
    
    private func setup() {
        messageServer.decodedMessage(using: decoders)
            .subscribe(onNext: { [unowned self] message in
                guard let message = message else {
                    return
                }
                self.handle(message: message)
            })
            .disposed(by: bag)
    }
    
    private func handle(message: WebRtcMessage) {
        switch message {
        case .iceCandidate(let iceCandidate):
            webRtcServerManager.setICECandidates(iceCandidate: iceCandidate as! RTCIceCandidate)
        case .sdpOffer(let sdp):
            webRtcServerManager.createAnswer(remoteSDP: sdp as! RTCSessionDescription)
        default:
            break
        }
    }
    
    /// Starts streaming
    func startStreaming() {
        messageServer.start()
        netServiceServer.publish()
    }
    
    deinit {
        netServiceServer.stop()
        messageServer.stop()
        webRtcServerManager.disconnect()
    }
}

extension ServerViewModel: WebRtcServerManagerDelegate {
    
    func localStreamAvailable(stream: RTCMediaStream) {
        didLoadLocalStream?(stream)
    }
    
    func answerSDPCreated(sdp: RTCSessionDescription) {
        let json = [WebRtcMessage.Key.answerSDP.rawValue: sdp.jsonDictionary()]
        guard let jsonString = json.jsonString else {
            return
        }
        messageServer.send(message: jsonString)
    }
    
    func iceCandidatesCreated(iceCandidate: RTCIceCandidate) {
        let json = [WebRtcMessage.Key.iceCandidate.rawValue: iceCandidate.jsonDictionary()]
        guard let jsonString = json.jsonString else {
            return
        }
        messageServer.send(message: jsonString)
    }
    
    func dataReceivedInChannel(data: NSData) {
        
    }
}
