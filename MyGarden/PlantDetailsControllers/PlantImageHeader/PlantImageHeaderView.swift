//
//  PlantImageHeaderView.swift
//  MyGarden
//
//  Created by Никита on 01.05.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

protocol PlantImageHeaderViewDelegate: class {
    func presentView(_ view: UIViewController, animated: Bool)
    func dismissView(animated: Bool)
    
    func addImage(_ image: UIImage)
}

class PlantImageHeaderView: UICollectionReusableView {
        
    static let reuseId = "PlantDetailsHeaderReuseId"
    
    weak var delegate: PlantImageHeaderViewDelegate?
    
    var plantImages: [UIImage] = []
    var collectionImageView: UICollectionView?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    fileprivate func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionImageView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionImageView?.showsHorizontalScrollIndicator = false
        collectionImageView?.isPagingEnabled = true
        collectionImageView?.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.7568627451, blue: 0.6980392157, alpha: 1)
        
        collectionImageView?.delegate = self
        collectionImageView?.dataSource = self
        collectionImageView?.register(PlantImageHeaderViewCell.self, forCellWithReuseIdentifier: PlantImageHeaderViewCell.reuseId)
    }
    
    fileprivate func setupLayout() {
        addSubview(collectionImageView!)
        collectionImageView?.anchor(top: topAnchor,
                                    leading: leadingAnchor,
                                    bottom: bottomAnchor,
                                    trailing: trailingAnchor)
        
        addSubview(titleLabel)
        titleLabel.anchor(leading: leadingAnchor,
                          bottom: bottomAnchor,
                          trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    fileprivate func presentAddImageActionSheet() {
        let alertController = UIAlertController(title: "Select", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let fromGalleryAction = UIAlertAction(title: "From gallery", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.delegate?.presentView(imagePicker, animated: true)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.delegate?.presentView(imagePicker, animated: true)
        }
        
        let deleteImageAction = UIAlertAction(title: "Delete image", style: .default) { (action) in
           // TODO: Delete Image
        }
        
        alertController.addAction(fromGalleryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(deleteImageAction)
        alertController.addAction(cancelAction)
        
        delegate?.presentView(alertController, animated: true)
    }
    
    public func setImages(_ images: [UIImage]?, withTitle title: String) {
        plantImages = images ?? []
        titleLabel.text = title
        collectionImageView?.reloadData()
    }
    
    fileprivate func scrollToEnd() {
        collectionImageView?.scrollToItem(at: IndexPath(item: plantImages.count - 1, section: 0), at: .right, animated: true)
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension PlantImageHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (plantImages.count != 0) ? plantImages.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlantImageHeaderViewCell.reuseId, for: indexPath) as! PlantImageHeaderViewCell
        if plantImages.count == 0 {
            cell.setImage(#imageLiteral(resourceName: "default-plant"))
            
        } else {
            cell.setImage(plantImages[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentAddImageActionSheet()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionImageView!.frame.width, height: collectionImageView!.frame.height)
    }
    
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PlantImageHeaderView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        plantImages.append(image)
        collectionImageView?.reloadData()
        delegate?.addImage(image)
        delegate?.dismissView(animated: true)
        scrollToEnd()
    }
    
}
