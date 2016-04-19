//
//  Constants.swift
//  PokemonCyclopaedia
//
//  Created by David Stroud on 19/04/2016.
//  Copyright © 2016 David Stroud. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

// create a closure (a block of code that will be called whenever we want). It's an empty closure "()" and it returns "->" nothing "()"
typealias DownloadComplete = () -> ()
