//
//  StartViewController.swift
//  SMX-03-IAmPoor
//
//  Created by Vyacheslav on 24.10.2023.
//

import UIKit

class StartViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let labelText = "I am poor"
        
        static let fontName = "HelveticaNeue-Bold"
        static let fontSize = 40.0
        
        static let imageName = "coal"
        
        static let labelBottomAnchor = -10.0
        static let imageHeight = 200.0
        static let imageWidth = 200.0
    }
    
    // MARK: Private Properties
    
    private let label = {
        let label = UILabel(frame: .zero)
        label.text = Constants.labelText
        
        let font = UIFont(name: Constants.fontName, size: Constants.fontSize) ?? UIFont.preferredFont(forTextStyle: .largeTitle)
        label.font = font
        
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let imageView = {
        let image = UIImage(named: Constants.imageName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configure()
    }

    // MARK: Private Methods
    
    private func configure() {
        view.backgroundColor = .orange
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth).isActive = true
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: imageView.topAnchor,
                                   constant: Constants.labelBottomAnchor).isActive = true
    }

}

