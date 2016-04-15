//
//  ViewController.swift
//  PokemonCyclopaedia
//
//  Created by David Stroud on 15/04/2016.
//  Copyright © 2016 David Stroud. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
                                        // implement the protocol, each has its methods. Ctrl-click to get more info on them.
    
    @IBOutlet weak var collection: UICollectionView!
    
    var pokemon = [Pokemon]() // empty pokemon array
    
    var musicPlayer: AVAudioPlayer! // remember to import AVFoundation above first.

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var pokemon = Pokemon(name: "Charizard", pokedexId: 6) // as an example of using the Pokemon.swift class
        
        collection.delegate = self
        collection.dataSource = self
        
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
            
            let poke = pokemon[indexPath.row]
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

    @IBAction func musicBtnPressed(sender: UIButton!) {
        
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }



}

