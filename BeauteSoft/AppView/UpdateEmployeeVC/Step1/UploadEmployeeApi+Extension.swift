//
//  UploadEmployeeApi+Extension.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 21/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
extension UpdateEmployeeVC {
    //MARK: - api for get gender list
    func getGender(){
        let actionURL = "\(base)\(Apis.getGender)\(siteCodeStr)"
        WebService.shared.getDataFrom(api: actionURL) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.arrGenderList.append(GenderList(fromDictionary: dict))
                })
                self.getRace()
            }
        }
        
    }
    //MARK: - api for get getRaces list
    func getRace(){
        let actionURL = "\(base)\(Apis.getRaces)\(siteCodeStr)"
        WebService.shared.getDataFrom(api: actionURL) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.arrRace.append(RaceList(fromDictionary: dict))
                })
                self.getNationality()
            }
        }
    }
    //MARK: - api for get getnationality list
    func getNationality(){
        let actionURL = "\(base)\(Apis.getNationality)\(siteCodeStr)"
        WebService.shared.getDataFrom(api: actionURL) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.arrNationality.append(NationalityList(fromDictionary: dict))
                })
                self.getRelegion()
            }
        }
    }
    //MARK: - api for get getRelegion list
    func getRelegion(){
        let actionURL = "\(base)\(Apis.getReligion)\(siteCodeStr)"
        WebService.shared.getDataFrom(api: actionURL) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.arrReligion.append(ReligionList(fromDictionary: dict))
                })
                self.getMartial()
            }
        }
    }
    //MARK: - api for get getMartial list
    func getMartial(){
        let actionURL = "\(base)\(Apis.getMaritalStatus)\(siteCodeStr)"
        WebService.shared.getDataFrom(api: actionURL) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.arrMaritalStatus.append(MartialLsit(fromDictionary: dict))
                })
                self.getSiteListing()
            }
        }
    }
    //MARK: - api for get getSiteListing list
    func getSiteListing(){
        let actionURL = "\(base)\(Apis.siteListing)\(siteCodeStr)"
        WebService.shared.getDataFrom(api: actionURL) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.arrSiteListing.append(SiteListingOption(fromDictionary: dict))
                })
            }
        }
    }

}
