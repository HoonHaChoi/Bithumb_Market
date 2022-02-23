//
//  HTTPError.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import Foundation

enum HTTPError: Error, CustomStringConvertible {
    case invalidURL
    case invalidRequset
    case statusCode(Int)
    case emptyData
    case failureDecode
    
    var description: String {
        switch self {
        case .invalidURL:
            return "잘못된 URL 입니다."
        case .invalidRequset:
            return "요청에 실패하였습니다."
        case .statusCode(let code):
            switch code {
            case 404:
                return "연결에 실패 하였습니다."
            case 5500:
                return "상장되지않은 코인 요청 입니다."
            default:
                return "알 수 없는 오류입니다. 잠시 후에 다시 실행해주세요."
            }
        case .emptyData:
            return "데이터가 없습니다."
        case .failureDecode:
            return "데이터 변환에 실패하였습니다."
        }
    }
}
