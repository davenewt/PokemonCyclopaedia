//
//  ViewController.swift
//  PokemonCyclopaedia
//
//  Created by David Stroud on 15/04/2016.
//  Copyright © 2016 David Stroud. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
                                        // implement the protocol, each has its methods. Ctrl-click to get more info on them.
    
    @IBOutlet weak var collection: UICollectionView!
    
    var pokemon = [Pokemon]() // empty pokemon array

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var pokemon = Pokemon(name: "Charizard", pokedexId: 6) // as an example of using the Pokemon.swift class
        
        collection.delegate = self
        collection.dataSource = self
        
        parsePokemonCSV()
        
    }
    
    func parsePokemonCSV() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")! // reference the pokemon.csv file
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
//            print(rows)
            for row in rows {
                let pokeId = Int(row["id"]!)! // grab the row number from the CSV and convert it to an integer
                let name = row["identifier"]! // 'identifier' is the name of the pokemon in the CSV
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
        } catch let err as  NSError {
            print(err.description)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            var poke = pokemon[indexPath.row]
            cell.configureCell(poke)
            
            return cell // if able to grab a cell of this type, configure it and then return it
            
        } else {
            
            return UICollectionViewCell() // else return a generic cell with nothing in it
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 718
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105,105)
    }




}

