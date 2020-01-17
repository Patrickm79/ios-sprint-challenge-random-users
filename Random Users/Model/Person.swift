//
//  Person.swift
//  Random Users
//
//  Created by Patrick Millet on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Person: Decodable {
    let firstName: String
    let lastName: String
    let title: String
    let email: String
    let thumbNail: URL
    let largePicture: URL
    let cell: String
    let id: String


    private enum PersonKeys: String, CodingKey {
        case name
        case picture
        case email
        case cell
        case id

        enum NameCodingKeys: String, CodingKey {
            case title
            case first
            case last
        }

        enum PictureCodingKeys: String, CodingKey {
            case thumbNail = "thumbnail"
            case large
        }

        enum IDCodingKeys: String, CodingKey {
            case name
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PersonKeys.self)
        email = try container.decode(String.self, forKey: .email)
        cell = try container.decode(String.self, forKey: .cell)

        let nameContainer = try container.nestedContainer(keyedBy: PersonKeys.NameCodingKeys.self, forKey: .name)
        firstName = try nameContainer.decode(String.self, forKey: .first)
        lastName = try nameContainer.decode(String.self, forKey: .last)
        title = try nameContainer.decode(String.self, forKey: .title)

        let pictureContainer = try container.nestedContainer(keyedBy: PersonKeys.PictureCodingKeys.self, forKey: .picture)
        let thumbNailPic = try pictureContainer.decode(String.self, forKey: .thumbNail)
        let largePic = try pictureContainer.decode(String.self, forKey: .large)

        thumbNail = URL(string: thumbNailPic)!
        largePicture = URL(string: largePic)!

        let idContainer = try container.nestedContainer(keyedBy: PersonKeys.IDCodingKeys.self, forKey: .id)
        id = try idContainer.decode(String.self, forKey: .name)
    }
}

struct Results: Decodable {
    let results: [Person]
}
