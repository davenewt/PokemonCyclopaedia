//
//  Pokemon.swift
//  PokemonCyclopaedia
//
//  Created by David Stroud on 15/04/2016.
//  Copyright © 2016 David Stroud. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _evoTxt: String!
    private var _evoId: String!
    private var _evoLevel: String!
    private var _pokemonUrl: String!
    
    var name: String {
        get {
            return _name
        }
    }
    
    var pokedexId: Int {
        get {
            return _pokedexId
        }
    }
    
    // not possible for name or pokedexId to be nil, because we declare them at init time (see further down). However, for other values, we should deal with what happens if they ARE nil... so...
    
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
            return _description
        }
    }
    
    var type: String {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
        }
    }
    
    var defense: String {
        get {
            if _defense == nil {
                _defense = ""
            }
            return _defense
        }
    }
    
    var height: String {
        get {
            if _height == nil {
                _height = ""
            }
            return _height
        }
    }

    var weight: String {
        get {
            if _weight == nil {
                _weight = ""
            }
            return _weight
        }
    }
    
    var attack: String {
        get {
            if _attack == nil {
                _attack = ""
            }
            return _attack
        }
    }
    
    var evoTxt: String {
        get {
            if _evoTxt == nil {
                _evoTxt = ""
            }
            return _evoTxt
        }
    }
    
    var evoId: String {
        get {
            if _evoId == nil {
                _evoId = ""
            }
            return _evoId
        }
    }
    
    var evoLevel: String {
        get {
            if _evoLevel == nil {
                _evoLevel = ""
            }
            return _evoLevel
        }
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            print(result.value.debugDescription) 
            // make sure we're successfully getting data from the API (can use this output to search for specific variable names to use below, handy!)
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String { // use if let, and cast to a string, BEFORE you attempt to use data!
                    self._weight = weight // assign it. If you ever have code in a closure "{}" you HAVE to use self. notation
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                // Make sure we're getting the right info
//                print(self._weight)
//                print(self._height)
//                print(self._attack)
//                print(self._defense)

                
                
                
                
                // types is an ARRAY of DICTIONARY objects. See 27min into https://www.udemy.com/ios9-swift/learn/v4/t/lecture/3447128
                if let types = dict["types"] as? [Dictionary<String,String>] where types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    if types.count > 1 {
                        for x in 1...types.count-1 {
//                        for var x = 1; x < types.count; x = x + 1 { // OLD c-style for loop syntax is deprecated http://stackoverflow.com/questions/36173379/warning-c-style-for-statement-is-deprecated-and-will-be-removed-in-a-future-ve
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                print("Selected Poké Type: \(self._type)")
                
                
                
                

                if let descArr = dict["descriptions"] as? [Dictionary<String,String>] where descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        print(nsurl)
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            
//                            print(response.result)
                            
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String,AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print("Selected Poké Description: \(self._description)")
                                }
                                
                            }
                            
                            completed() // this signals we have finished downloading, and takes us back into PokemonDetailVC.swift, see 32min in https://www.udemy.com/ios9-swift/learn/v4/t/lecture/3450386
                            
                        }
                    }
                    
                } else {
                    self._description = "NO DESCRIPTION? DO WE EVER GET HERE?"
                }
//                print("Selected Poké Description outside of closure always returns nil, look!: \(self._description)")
                // this returns nil, but inside the closure, above, we get the description OK. THIS IS BECAUSE requests are ASYNCHRONOUS! See 24min in https://www.udemy.com/ios9-swift/learn/v4/t/lecture/3450386
                
                
                
                
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String { // the v1 API we're using only ever provides one evolution
                        
                        if to.rangeOfString("mega") == nil { // if "mega" isn't mentioned in the evolution, we're good to proceed (we're excluding weird mega evolutions for this app)
                            // we grab the number out of the string url
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.stringByReplacingOccurrencesOfString("\(URL_POKEMON)", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._evoId = num
                                self._evoTxt = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._evoLevel = "\(lvl)"
                                }
                                
//                                print("Selected Poké Next Evo ID: \(self._evoId)")
//                                print("Selected Poké Next Evo Txt: \(self._evoTxt)")
//                                print("Selected Poké Next Evo Lvl: \(self._evoLevel)")
                                
                            }
                            
                        } else {
                            self._evoTxt = "To a mega!"
                            // This is what we're not accounting for, in this version of the app. NB evoId and evoTxt values will be nil
                        }
                        
                    }
                    
                }
                print("Selected Poké Next Evo ID: \(self._evoId)")
                print("Selected Poké Next Evo Txt: \(self._evoTxt)")
                print("Selected Poké Next Evo Lvl: \(self._evoLevel)")
                
            }
        }
        
    }
    
    
}