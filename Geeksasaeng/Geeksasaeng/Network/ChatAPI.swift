//
//  ChatAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/12/18.
//

import Foundation
import Alamofire

/* 배달파티 채팅방 생성 API의 Request body */
struct CreateChatRoomInput : Encodable {
    var accountNumber: String?
    var bank: String?
    var category: String?
    var maxMatching: Int?
    var title: String?
    var deliveryPartyId: Int?
}

/* 배달파티 채팅방 생성 API의 Response */
struct CreateChatRoomModel : Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : CreateChatRoomModelResult?
}

struct CreateChatRoomModelResult: Decodable {
    var partyChatRoomId: String?
    var title: String?
}

/* 채팅방 입장 API의 Request body */
struct JoinChatInput: Encodable {
    var partyChatRoomId: String?
}

/* 채팅방 입장 API의 Response */
struct JoinChatModel: Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : JoinChatModelResult?
}
struct JoinChatModelResult: Decodable {
    var enterTime: String?
    var partyChatRoomId: String?
    var partyChatRoomMemberId: String?
    var remittance: Bool?
}

/* 채팅방 목록 조회 API의 Response */
struct ChatRoomListModel : Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : ChatRoomListModelResult?
}

struct ChatRoomListModelResult: Decodable {
    var finalPage: Bool?
    var parties: [ChatRoom]?
}

struct ChatRoom: Decodable {
    var roomId: String?
    var roomTitle: String?
    var enterTime: String?
}

/* 채팅방 사진 전송 */
struct ChatImageSendInput: Encodable {
    var chatId: String?
    var chatRoomId: String?
    var chatType: String?
    var content: String?
    var isImageMessage: Bool?
    var isSystemMessage: Bool?
}
struct ChatImageSendModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: String?
}

/* 주문 완료 */
struct OrderCompletedInput: Encodable {
    var roomId: String?
}
struct OrderCompletedModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: String?
}

/* 방장 퇴장 */
struct ExitChiefInput: Encodable {
    var roomId: String?
}
struct ExitChiefModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: ExitChiefModelResult?
}
struct ExitChiefModelResult: Decodable {
    var message: String?
}

/* 파티원 퇴장 */
struct ExitMemberInput: Encodable {
    var roomId: String?
}

struct ExitMemberModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: ExitMemberModelResult?
}
struct ExitMemberModelResult: Decodable {
    var message: String?
}

/* 송금 완료 */
struct CompleteRemittanceInput: Encodable {
    var roomId: String?
}
struct CompleteRemittanceModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: String?
}

/* 강제퇴장을 위한 참여자들 정보 불러오기 */
struct InfoForForcedExitInput: Encodable {
    var partyId: Int?
    var roomId: String?
}
struct InfoForForcedExitModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: [InfoForForcedExitModelResult]?
}
struct InfoForForcedExitModelResult: Decodable {
    var memberId: Int?
    var chatMemberId: String?
    var userName: String?
    var userProfileImgUrl: String?
    var accountTransferStatus: String?
}

/* 채팅방 강제 퇴장 */
struct ForcedExitInput: Encodable {
    var removedChatMemberIdList: [String]?
    var roomId: String?
}
struct ForcedExitModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: ForcedExitModelResult?
}
struct ForcedExitModelResult: Decodable {
    var message: String?
}

class ChatAPI {
    
    /* 생성된 배달파티의 채팅방 생성 요청 */
    public static func requestCreateChatRoom(_ input : CreateChatRoomInput,
                                             completion: @escaping (Bool, CreateChatRoomModelResult?) -> Void) {
        let url = "https://geeksasaeng.shop/party-chat-room"
        
        AF.request(url, method: .post,
                   parameters: input,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: CreateChatRoomModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 채팅방 생성 성공", result)
                    completion(result.isSuccess!, result.result)
                } else {
                    print("DEBUG:", result.result!)
                    completion(result.isSuccess!, nil)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
                completion(false, nil)
            }
        }
    }
    
    /* 파티장이 아닌 유저가 신청하기 눌렀을 때 유저를 채팅방의 멤버로 추가할 때 사용 */
    public static func requestJoinChat(_ parameter : JoinChatInput,
                                        completion: @escaping (Bool, JoinChatModelResult?) -> Void)
    {
        let url = "https://geeksasaeng.shop/party-chat-room/member"
        
        AF.request(url,
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: JoinChatModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 채팅방 입장 성공", result)
                    completion(result.isSuccess!, result.result)
                } else {
                    print("DEBUG: 채팅방 입장 실패", result.message!)
                    completion(result.isSuccess!, nil)
                }
            case .failure(let error):
                print("DEBUG: 채팅방 입장 실패", error.localizedDescription)
                completion(false, nil)
            }
        }
    }
    
    // 채팅방 상세조회 API 연동
    public static func getChattingRoomInfo(_ parameter: ChattingRoomInput, completion: @escaping (ChattingRoomResult?) -> (Void)) {
        guard let roomId = parameter.chatRoomId else { return }
        let URL = "https://geeksasaeng.shop/party-chat-room/\(roomId)"
        AF.request(URL,
                   method: .get,
                   parameters: nil,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ChattingRoomModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 채팅방 상세조회 성공")
                    // result 값을 탈출 클로저를 통해 전달
                    completion(result.result)
                } else {
                    print("DEBUG: 채팅방 상세조회 실패", result.message!)
                    completion(nil)
                }
            case .failure(let error):
                print("DEBUG: 채팅방 상세조회 실패", error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    /* 이미지 전송 */
    public static func sendImage(_ parameter: ChatImageSendInput, imageData: [UIImage], completion: @escaping (ChatImageSendModel?) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/chatimage"
        let header : HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Authorization": "Bearer " + (LoginModel.jwt ?? "")
        ]
        let parameters: [String: Any] = [
            "chatId": parameter.chatId!,
            "chatRoomId": parameter.chatRoomId!,
            "chatType": parameter.chatType!,
            "content": parameter.content!,
            "isImageMessage": parameter.isImageMessage!,
            "isSystemMessage": parameter.isSystemMessage!
        ]
        
        print("==========", parameters)
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            imageData.forEach { image in
                if let pngImage = image.pngData() {
                    multipartFormData.append(pngImage, withName: "images", fileName: "\(pngImage).png", mimeType: "image/png")
                }
            }
            print("DEBUG: 이미지 데이터", multipartFormData)
        }, to: URL, usingThreshold: UInt64.init(), method: .post, headers: header)
        .validate()
        .responseDecodable(of: ChatImageSendModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 이미지 업로드 성공", result.message!)
                } else {
                    print("DEBUG: 이미지 업로드 실패", result.message!)
                }
                completion(result)
            case .failure(let error):
                print("DEBUG: 이미지 업로드 실패", error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    /* 방장의 주문완료 */
    public static func orderCompleted(_ parameter: OrderCompletedInput, completion: @escaping (OrderCompletedModel?) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/order"
        AF.request(URL, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: OrderCompletedModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("주문완료 처리 성공")
                } else {
                    print("DEBUG: ", result.message!)
                }
                completion(result)
            case .failure(let error):
                print("DEBUG: ", error.localizedDescription)
                completion(nil)
            }
        }   
    }
    
    /* 방장 나가기 */
    public static func exitChief(_ parameter: ExitChiefInput, completion: @escaping (Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/chief"
        AF.request(URL, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ExitChiefModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 방장 채팅방 나가기 완료")
                    completion(true)
                } else {
                    print("DEBUG: .success: 방장 채팅방 나가기 실패, ", result.message!)
                    completion(false)
                }
            case .failure(let error):
                print("DEBUG: .failure: 방장 채팅방 나가기 실패, ", error.localizedDescription)
                completion(false)
            }
        }
    }
    
    /* 파티원 나가기 */
    public static func exitMember(_ parameter: ExitMemberInput, completion: @escaping (Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/members/self"
        AF.request(URL, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ExitMemberModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 파티원 채팅방 나가기 완료")
                    completion(true)
                } else {
                    print("DEBUG: 파티원 채팅방 나가기 실패", result.message!)
                    completion(false)
                }
            case .failure(let error):
                print("DEBUG: 파티원 채팅방 나가기 실패", error.localizedDescription)
                completion(false)
            }
        }
    }
    
    /* 채팅방 탭에 왔을 때 채팅방 목록 조회 요청 */
    public static func requestGetChatRoomList(cursor: Int,
                                             completion: @escaping (ChatRoomListModel?, String?) -> Void)
    {
        let url = "https://geeksasaeng.shop/party-chat-room"
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (LoginModel.jwt ?? "")]
        
        // Query String을 통해 요청
        let parameters: Parameters = [
            "cursor": cursor
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding(destination: .queryString),
                   headers: headers)
        .validate()
        .responseDecodable(of: ChatRoomListModel.self) { response in
            switch response.result {
            case .success(let model):
                if model.isSuccess! {
                    print("DEBUG: 채팅방 목록 조회 성공", model.result)
                    completion(model, nil)
                } else {
                    print("DEBUG: 채팅방 목록 조회 실패", model.message)
                    completion(nil, model.message)
                }
            case .failure(let error):
                print("DEBUG: 채팅방 목록 조회 실패", error.localizedDescription)
                completion(nil, "채팅방 목록을 불러오지 못했습니다.")
            }
        }
    }
    
    /* 송금 완료 */
    public static func completeRemittance(_ parameter: CompleteRemittanceInput, completion: @escaping (Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/members/remittance"
        AF.request(URL, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: CompleteRemittanceModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("송금 완료")
                    completion(true)
                } else {
                    print("송금 완료 실패")
                    completion(false)
                }
            case .failure(let error):
                print("DEBUG: ", error.localizedDescription)
                completion(false)
            }
        }
    }
    
    /* 방장이 파티원을 채팅방에서 강제퇴장 */
    public static func forcedExitChat(_ parameter: ForcedExitInput, completion: @escaping (ForcedExitModel?) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/members"
        AF.request(URL, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ForcedExitModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 강제 퇴장 완료")
                    completion(result)
                } else {
                    print("DEBUG: .success 강제 퇴장 실패, ", result.message!)
                    completion(result)
                }
            case .failure(let error):
                print("DEBUG: .failure 강제 퇴장 실패, ", error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    // 매칭 마감 API 호출 함수
    public static func closeMatching(_ parameter: CloseMatchingInput, completion: @escaping (Bool) -> Void) {
        guard let partyId = parameter.partyId else { return }
        let url = "https://geeksasaeng.shop/party-chat-room/matching-status"
        
        var parameters: Parameters = [
            "partyId": partyId
        ]
        AF.request(url, method: .patch, parameters: parameters, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: CloseMatchingModel.self) { response in
            switch response.result {
            case .success(let result):
                print("DEBUG:", result)
                completion(result.isSuccess!)
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
                completion(false)
            }
        }
    }
    
    // 배달 완료 API 호출 함수 -> 서버에 푸시 알림 전송 요청
    public static func completeDelivery(_ input: CompleteDeliveryInput, completion: @escaping (Bool, CompleteDeliveryModel?) -> ()) {
        let url = "https://geeksasaeng.shop/party-chat-room/delivery-complete"
        
        AF.request(url,
                   method: .patch,
                   parameters: input,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: CompleteDeliveryModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 배달 완료 성공", result.message)
                } else {
                    print("DEBUG: 배달 완료 실패", response, result)
                }
                completion(result.isSuccess!, result)
            case .failure(let error):
                print("DEBUG: 배달 완료 실패", error.localizedDescription)
                completion(false, nil)
            }
        }
    }
    
    // 강제퇴장을 위한 채팅 참여자들 정보 가져오기
    public static func getInfoForForcedExit(input: InfoForForcedExitInput,
                                            completion: @escaping (Bool, [InfoForForcedExitModelResult]?) -> ()) {
        guard let partyId = input.partyId, let roomId = input.roomId else { return }
        let url = "https://geeksasaeng.shop/party-chat-room/\(partyId)/\(roomId)/members"
        
        AF.request(url,
                   method: .get,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: InfoForForcedExitModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 채팅 참여자들 정보 가져오기 성공", result.message)
                } else {
                    print("DEBUG: 채팅 참여자들 정보 가져오기 실패", response, result)
                }
                completion(result.isSuccess!, result.result)
            case .failure(let error):
                print("DEBUG: 채팅 참여자들 정보 가져오기 실패", error.localizedDescription)
                completion(false, nil)
            }
        }
    }
    
    // 채팅방 내 멤버 프로필 클릭 시 정보 조회 API
    public static func getInfoChattingMember(input: ChattingMemberInput,
                                            completion: @escaping (ChattingMemberResultModel?) -> ()) {
        guard let memberId = input.memberId, let roomId = input.chatRoomId else { return }
        let url = "https://geeksasaeng.shop/party-chat-room/\(roomId)/\(memberId)/member-profile"
        
        AF.request(url,
                   method: .get,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ChattingMemberModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 채팅방 내 멤버 프로필 클릭 시 정보 조회 성공", result.message)
                } else {
                    print("DEBUG: 채팅방 내 멤버 프로필 클릭 시 정보 조회 실패", response, result)
                }
                completion(result.result)
            case .failure(let error):
                print("DEBUG: 채팅 참여자들 정보 가져오기 실패", error.localizedDescription)
                completion(nil)
            }
        }
    }
    
}


