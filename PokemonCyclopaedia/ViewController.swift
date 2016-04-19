//
//  ViewController.swift
//  PokemonCyclopaedia
//
//  Created by David Stroud on 15/04/2016.
//  Copyright © 2016 David Stroud. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
                                        // implement the protocol, each has its methods. Ctrl-click to get more info on them.
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]() // empty pokemon array
    var filteredPokemon = [Pokemon]() // for searching
    var musicPlayer: AVAudioPlayer! // remember to import AVFoundation above first.
    var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var pokemon = Pokemon(name: "Charizard", pokedexId: 6) // as an example of using the Pokemon.swift class
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done // change the word on the return key when searching
        
        parsePokemonCSV()
        initAudio()
        
    }
    
    func initAudio() { // make the music play!
        
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")
//        print(path)
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 // infinitely loop
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
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
            
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            cell.configureCell(poke)
            
            return cell // if able to grab a cell of this type, configure it and then return it
            
        } else {
            
            return UICollectionViewCell() // else return a generic cell with nothing in it
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemon.count
        }
        return pokemon.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105,105)
    }

    @IBAction func musicBtnPressed(sender: UIButton!) {
        
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true) // hide the keyboard when user presses the search button in the search bar
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            // todo: when you type in the field then delete all the text, this assumes you're done searching and exits search mode. I want to be able to see if the cursor is still in the search bar, and only if someone clicks off it, it will end searching.
            inSearchMode = false
            view.endEditing(true) // close the keyboard
            collection.reloadData() // reload the data! Must remember to do this!
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString // convert anything typed into lowercase, just in case someone types in caps
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            // $0 is a placeholder for the element being looked at
            // this takes the elements from the pokemon array, sees if each one contains the string being searched for, and if it is, adds it to the filteredPokemon array automatically!
            // explained at 9mins in at https://www.udemy.com/ios9-swift/learn/v4/t/lecture/3450388
            collection.reloadData() // reload the data! Must remember to do this!
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PokemonDetailVC" { // at the moment, this is the only VC we have
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC { // grab the destination VC, and cast it into the PokemonDetailVC class (we know this will work)
                if let poke = sender as? Pokemon { // cast the sender (poke) into the Pokemon object (again, we know this will work)
                    detailsVC.pokemon = poke
                }
            }
        }
    }

}

