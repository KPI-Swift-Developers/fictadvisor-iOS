//
//  TeachersService.swift
//  fictadvisor-iOS
//
//  Created by Саша Василенко on 27.09.2022.
//

import Foundation
import Alamofire

struct Teacher: Codable {
    let id, link, firstName, middleName: String
    let lastName, state: String
    let rating: Double
}

typealias Teachers = [Teacher]

protocol TeachersServiceTarget {
    func getTeachers(page: Int, sort: SortingType,completion: @escaping(Teachers) -> Void, errorCompletition: ((Error) -> Void)?)
    func searchTeacher(text: String, completion: @escaping(Teachers) -> Void, errorCompletition: ((Error) -> Void)?)
}

class TeachersService: RestService {
    private func linkString(page: Int, sort: SortingType) -> String {
        return baseURL + "teachers?page=\(page)&page_size=\(standardPages)&sort=\(sort.urlName)"
    }
    private func linkStringForSearch(for text: String) -> String {
        return baseURL + "teachers?&search=\(text.addingPercentEncoding(withAllowedCharacters: CharacterSet.afURLQueryAllowed)!)"
    }
}

extension TeachersService: TeachersServiceTarget {
    
    func searchTeacher(text: String, completion: @escaping (Teachers) -> Void, errorCompletition: ((Error) -> Void)?) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        AF.request(linkStringForSearch(for: text), method: .get).responseDecodable(of: APIArrayData<Teacher>.self, decoder: decoder) { (response) in
            if response.response?.statusCode == 200, let value = response.value {
                completion(value.items)
            }
        }
    }
    
    func getTeachers(page: Int, sort: SortingType ,completion: @escaping (Teachers) -> Void, errorCompletition: ((Error) -> Void)?) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        AF.request(linkString(page: page, sort: sort), method: .get).responseDecodable(of: APIArrayData<Teacher>.self, decoder: decoder) { (response) in
            if response.response?.statusCode == 200, let value = response.value {
                completion(value.items)
            }
        }
    }
}
