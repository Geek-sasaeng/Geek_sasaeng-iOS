//
//  WebSocketChattingVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/10/13.
//

import UIKit

import SnapKit
import Then
import RMQClient

class WebSocketChattingVC: UIViewController {
    
    // MARK: - SubViews
    
    lazy var textfield = UITextView().then {
        $0.textColor = .black
        $0.font = UIFont.customFont(.neoMedium, size: 18)
    }
    
    lazy var receivedText = UILabel().then {
        $0.backgroundColor = .darkGray
        $0.text = "Hi"
        $0.font = UIFont.customFont(.neoMedium, size: 18)
        $0.textColor = .white
        $0.numberOfLines = 0
    }

    lazy var button = UIButton().then {
        $0.setTitle("Submit", for: .normal)
        $0.backgroundColor = .mainColor
        $0.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    // MARK: - Variables
    
    let exchangeName = "chatting-room-exchange-test2"
    let queueName = "chatting-room-queue-test2"
    let routingKey = ["chatting.test.room.6368f06515794524d1468be4"]
    let rabbitMQUri = "amqp://\(Keys.idPw)@\(Keys.address)"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setLayouts()
        emitLogTopic("Hello World")
        receiveLogsTopic()
        print("[Rabbit]", rabbitMQUri)
    }
    
    // MARK: - Functions
    
    // Views Just For Test
    private func setLayouts() {
        view.addSubview(textfield)
        view.addSubview(receivedText)
        view.addSubview(button)
        
        textfield.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
        button.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(30)
            make.top.equalTo(textfield.snp.bottom).offset(30)
            make.centerX.equalTo(textfield)
        }
        receivedText.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(100)
        }
    }
    
    // 채팅 수신
    private func receiveLogsTopic() {
        let conn = RMQConnection(uri: rabbitMQUri, delegate: RMQConnectionDelegateLogger())
        conn.start()
        let ch = conn.createChannel()
        
        let x = ch.topic(exchangeName)
        let q = ch.queue(queueName, options: .durable)
        for key in routingKey {
            q.bind(x, routingKey: key)
        }
        
        print("[Rabbbit] Waiting for logs.")
        q.subscribe({(_ message: RMQMessage) -> Void in
            guard let msg = String(data: message.body, encoding: .utf8) else { return }
            
            // str - decode
            do {
                // Chatting 구조체로 decode.
                let decoder = JSONDecoder()
                let data = try decoder.decode(Chatting.self, from: message.body)
                print("[Rabbit]", data)
                // Chatting(id=6359598f3391e75a148b7dce, content=태규3, baseEntity=BaseEntity(createdAt=10/26/22, 4:00 PM, updatedAt=10/26/22, 4:00 PM, status=ACTIVE))
                
                guard let id = data.chattingRoomId, let content = data.content, let createdAt = data.createdAt else { return }
                print("[Rabbit] 값 가져오기: ", id, content, createdAt) // 6359598f3391e75a148b7dce, 태규3, 2022-10-29 16:02:17
                
                DispatchQueue.main.async {
                    self.receivedText.text = "\(id)\n\(content)\n\(createdAt)"
                }
            } catch {
                print(error)
            }
            
            print("[Rabbit] Received RoutingKey: \(message.routingKey!), Message: \(msg)")
            print("[Rabbit] Message Info: \n consumerTag \(message.consumerTag ?? "nil값"), deliveryTag \(message.deliveryTag ?? 0), exchangeName \(message.exchangeName ?? "nil값")")
        })
    }
    
    // 채팅 발신 -> 사실상 우리쪽에선 필요없음.
    private func emitLogTopic(_ msg: String) {
        let conn = RMQConnection(uri: rabbitMQUri, delegate: RMQConnectionDelegateLogger())
        conn.start()
        let ch = conn.createChannel()
//        Chatting(id=635954c8fed92750e529f1b6, content=태규3, baseEntity=BaseEntity(createdAt=10/26/22, 3:39 PM, updatedAt=10/26/22, 3:39 PM, status=ACTIVE)))
        let x = ch.topic(exchangeName)
        for key in routingKey {
            x.publish(msg.data(using: .utf8)!, routingKey: key)
        }
        print("[Rabbit] Sent '\(msg)'")
        conn.close()
    }
    
    
    // MARK: - @objc Functions
    
    @objc
    private func tapButton() {
        print("[Rabbit] tap button")
        emitLogTopic(textfield.text)
        textfield.text = ""
    }
}
