//
//  SessionDescriptionDelegate.swift
//  Baby Monitor
//

final class RTCSessionDescriptionDelegateProxy: NSObject, RTCSessionDescriptionDelegate {

    var onDidCreateSessionDescription: ((RTCPeerConnection, RTCSessionDescription) -> Void)?
    var onDidSetSessionDescription: ((RTCPeerConnection) -> Void)?

    func peerConnection(_ peerConnection: RTCPeerConnection, didCreateSessionDescription sdp: RTCSessionDescription, error: Error?) {
        guard error == nil else { return }
        onDidCreateSessionDescription?(peerConnection, sdp)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didSetSessionDescriptionWithError error: Error?) {
        guard error == nil else { return }
        onDidSetSessionDescription?(peerConnection)
    }
    
}
