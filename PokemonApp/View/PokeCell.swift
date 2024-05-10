//
//  PokeCell.swift
//  PokemonApp
//
//  Created by Vladan Randjelovic on 10.5.24..
//

import UIKit

class PokeCell: UICollectionViewCell {

    @IBOutlet weak var cellContainerview: UIView!
    
    @IBOutlet weak var cellNameLabel: UILabel!
    
    @IBOutlet weak var cellImageView: UIImageView!

    @IBOutlet var cellContainerView: CardView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
