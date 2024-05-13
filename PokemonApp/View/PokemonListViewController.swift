//
//  PokemonListViewController.swift
//  PokemonApp
//
//  Created by Vladan Randjelovic on 9.5.24..
//

import UIKit
import Kingfisher
class PokemonListViewController: UICollectionViewController, UISearchBarDelegate {
    
    //MARK: - Variables, Componenets and Outlets
    let customCellId                 = "PokeCell"
    let leftRightPadding             = 15.0
    let searchController             = UISearchController(searchResultsController: nil)
    var filteredList                 : [Pokemon] = []
    var listViewModel                : PokemonListViewModel!
    var pokemonId                    : String = ""
    var isEmpty                      : Bool = false
    
    private lazy var imageView       : UIImageView = {
        let myImageView         = UIImageView()
        myImageView.image       = UIImage(named: "emptySearch")
        myImageView.contentMode = .scaleAspectFill
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        return myImageView
    }()
    
    private lazy var backgroundOfImageView  : UIView = {
        let containerView             = UIView()
        containerView.backgroundColor = UIColor(named: "backgroundColor")
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var searchNulLabel : UILabel = {
        let label           = UILabel()
        label.text          = "Sorry... \n I don't know anyone by that name."
        label.textColor     = .yellow
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureCollectionView()
        navigationController?.navigationBar.barTintColor = UIColor.green
        title           = "Pokemon App"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        fetchPokemonData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Enter Search Here", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    private func fetchPokemonData() {
        // Show activity indicator
        collectionView.toggleActivityIndicator()
        let pokemonManager = PokemonManager()
        // Initialize PokemonListViewModel with fetching pokemons
        listViewModel = PokemonListViewModel(pokemonManager: pokemonManager) { [weak self] pokemons, error in
            DispatchQueue.main.async {
                // Hide activity indicator
                self?.collectionView.toggleActivityIndicator()
                
                if let error = error {
                    // Handle error
                    print("Error fetching Pokémon data: \(error)")
                    return
                }
                
                // Update UI with fetched data
                self?.filteredList = pokemons ?? []
                self?.collectionView.reloadData()
            }
        }
    }
    //MARK: - Configuration for CollectionView
    
    
    func configureCollectionView() {
        collectionView.dataSource                = self
        collectionView.delegate                  = self
        collectionView.backgroundColor = .green
        let nibCell                              = UINib(nibName: customCellId, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: customCellId)
        collectionView.collectionViewLayout      = UICollectionViewFlowLayout()
        let flow                                 = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset                        = UIEdgeInsets(top: 20, left: leftRightPadding, bottom: 0, right: leftRightPadding)
        collectionView.reloadData()
    }
    
    func configureSearchBar() {
        navigationItem.searchController                   = searchController
        navigationItem.hidesSearchBarWhenScrolling        = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate               = self
        searchController.searchBar.searchTextField.textColor = .white
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredList.count
    }
    
    
    //MARK: CellForItemAt
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell                    = collectionView.dequeueReusableCell(withReuseIdentifier: customCellId, for: indexPath) as! PokeCell
        let chosedPokemon           = filteredList[indexPath.item]
        cell.cellNameLabel.text     = chosedPokemon.name?.firstUppercased
        
        listViewModel.getPokemonIdFromUrl(url: chosedPokemon.url) { resultId in
            self.pokemonId = resultId!
        }
        let imageUrl = makeImageURL(pokemonId: pokemonId)
        cell.cellImageView.kf.setImage(with: URL(string: imageUrl))
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func makeImageURL(pokemonId: String) -> String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonId).png"
    }
    
    //MARK:  didSelectItemAt
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC                      =  PokemonDetailsViewController()
        let chosedPokemon                 = filteredList[indexPath.item]
        listViewModel.getPokemonIdFromUrl(url: chosedPokemon.url) { resultId in
            self.pokemonId = resultId!
        }
        detailVC.viewModel.pokeId        =  Int(pokemonId)
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        
    }
    
    //MARK: - Search Bar
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredList = listViewModel.pokemonList
        self.collectionView.reloadData()
        backgroundOfImageView.removeFromSuperview()
        collectionView.isHidden = false
    }
    
    func createImageView() {
        view.addSubview(backgroundOfImageView)
        backgroundOfImageView.addSubview(imageView)
        backgroundOfImageView.addSubview(searchNulLabel)
        NSLayoutConstraint.activate([
            backgroundOfImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundOfImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundOfImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundOfImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchNulLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchNulLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -16),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            
        ])
    }
    
    func showImageView(isSearchNil: Bool){
        if isSearchNil == true {
            collectionView.isHidden = true
            createImageView()
        }
        else {
            imageView.removeFromSuperview()
            backgroundOfImageView.removeFromSuperview()
            collectionView.isHidden = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredList = []
        if searchText == "" {
            filteredList = listViewModel.pokemonList
            backgroundOfImageView.removeFromSuperview()
            collectionView.isHidden = false
        } else {
            for poke in listViewModel.pokemonList {
                guard let name = poke.name else { return }
                if name.lowercased().contains(searchText.lowercased()) {
                    filteredList.append(poke)
                }
            }
            if filteredList.isEmpty {
                self.showImageView(isSearchNil: true)
            } else {
                self.showImageView(isSearchNil: false)
            }
        }
        self.collectionView.reloadData()
    }
}

//MARK: Size of cells
extension PokemonListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize                     = UIScreen.main.bounds
        let screenWidth                    = screenSize.width
        let screenHeight                   = screenSize.height
        
        return CGSize(width: (screenWidth - (3 * leftRightPadding)) / 2, height: screenHeight / 4)
    }
}
