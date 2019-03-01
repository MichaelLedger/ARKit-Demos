//
//  MultipeerSession.swift
//  ARPainter
//
//  Created by MountainX on 2019/3/1.
//  Copyright © 2019 MTX Software Technology Co.,Ltd. All rights reserved.
//

/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A simple abstraction of the MultipeerConnectivity API as used in this app.
 */

import MultipeerConnectivity

/// - Tag: MultipeerSession
class MultipeerSession: NSObject {
    static let serviceType = "ar-multi-sample"
    
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private var session: MCSession!
    private var serviceAdvertiser: MCNearbyServiceAdvertiser!
    private var serviceBrower: MCNearbyServiceBrowser!
    
    private let receivedDataHandler: (Data, MCPeerID) -> Void
    
    // MARK: MultipeerSetup
    
    /*
     在Swift3中，闭包默认是非逃逸的。在Swift3之前，事情是完全相反的：那时候逃逸闭包是默认的，对于非逃逸闭包，你需要标记@noescaping。Swift3的行为更好。因为它默认是安全的：如果一个函数参数可能导致引用循环，那么它需要被显示地标记出来。@escaping标记可以作为一个警告，来提醒使用这个函数的开发者注意引用关系。非逃逸闭包可用被编译器高度优化，快速的执行路径将被作为基准而使用，除非你在有需要的时候显式地使用其他方法。
     
     @escaping标明这个闭包是会“逃逸”,通俗点说就是这个闭包在函数执行完成之后才被调用。
     */
    init(receivedDataHandler: @escaping (Data, MCPeerID) -> Void) {
        self.receivedDataHandler = receivedDataHandler
        
        super.init()
        
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: MultipeerSession.serviceType)
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        
        serviceBrower = MCNearbyServiceBrowser(peer: myPeerID, serviceType: MultipeerSession.serviceType)
        serviceBrower.delegate = self
        serviceBrower.startBrowsingForPeers()
    }
    
    func sendToAllPeers(_ data: Data) {
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("error sending data to peers: \(error.localizedDescription)")
        }
    }
    
    var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }
}

extension MultipeerSession: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // not used
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        receivedDataHandler(data, peerID)
    }
    
    /*
     当我们在开发过程中，遇到不想让别人调用而又不得不将其暴漏出来的方法时，一个最常见并且合理的需求就是”抽象类型或者抽象函数“。在很多语言中都有这样的特性:父类定义了某个方法，但是自己并不给出具体实现，而是要求继承他的子类去实现这个方法，而在 OC 和 Swift 中都没有直接的这样的抽象函数语法支持。在面对这种情况时，为了确保子类实现这些方法，而父类中的方法不被错误的调用，我们就可以利用 fatalError 来在父类中强制抛出错误，以保证使用这些代码的开发者留意到他们必须在自己的子类中实现相关方法。
     
     不仅仅是对于类似抽象函数的使用中可以选择 fatalError,对于其他一切我们不希望别人随意调用，但是又不得不去实现的方法，我们都应该使用 fatalError 来避免任何可能的误会。比如父类标明了某个 init 方法是 required 的，但是你的子类永远不会使用这个方法来初始化时，就可以采用类似的方法，被广泛使用(以及被广泛讨厌的)init(coder: NSCoder)就是一个例子。在子类中我们往往会写:
     
     required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }
     */
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        fatalError("This service does not send/receive streams.")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        fatalError("This service does not send/receive resources.")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        fatalError("This service does not send/receive resources.")
    }
}

extension MultipeerSession: MCNearbyServiceAdvertiserDelegate {
    /// - Tag: AcceptInvite
    // MARK: AcceptInvite
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Call handler to accept invitation and join the session.
        invitationHandler(true, self.session)
    }
}

extension MultipeerSession: MCNearbyServiceBrowserDelegate {
    /// - Tag: FoundPeer
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // This app doesn't do anything with non-invited peers, so there's nothing to do here.
    }
}
