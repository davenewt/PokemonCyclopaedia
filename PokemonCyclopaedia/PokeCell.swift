//
//  PokeCell.swift
//  PokemonCyclopaedia
//
//  Created by David Stroud on 15/04/2016.
//  Copyright © 2016 David Stroud. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalizedString // because names in our CSV aren't capitalised
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
    
}
