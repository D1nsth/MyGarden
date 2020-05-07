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
    func deleteImageBy(_ indexImage: Int)
}

class PlantImageHeaderView: UICollectionReusableView {
        
    static let reuseId = "PlantDetailsHeaderReuseId"
    static let nib = UINib(nibName: String(describing: PlantImageHeaderView.self), bundle: nil)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionImageView: UICollectionView!
    @IBOutlet weak var actionsWithImageButton: UIButton!
    
    weak var delegate: PlantImageHeaderViewDelegate?
    
    var plantImages: [UIImage] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
 
    fileprivate func setupCollectionView() {
        collectionImageView.delegate = self
        collectionImageView.dataSource = self
        collectionImageView.register(PlantImageHeaderViewCell.self, forCellWithReuseIdentifier: PlantImageHeaderViewCell.reuseId)
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

        let deleteImageAction = UIAlertAction(title: "Delete image", style: .default) { [weak self] (action) in
            let cell = self?.collectionImageView.visibleCells.first as! PlantImageHeaderViewCell
            guard let image = cell.getImage() else {
                print("(PlantImageHeaderView): Failed get image")
                return
            }
            
            guard let index = self?.plantImages.firstIndex(of: image) else {
                print("(PlantImageHeaderView): Failed get index by image")
                return
            }
            
            if (index + 1 != self?.plantImages.count) {
                self?.scrollTo(index + 1)
            }
            self?.plantImages.remove(at: index)
            self?.collectionImageView.reloadData()
            self?.delegate?.deleteImageBy(index)
        }
        
        alertController.addAction(fromGalleryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(deleteImageAction)
        alertController.addAction(cancelAction)
        
        delegate?.presentView(alertController, animated: true)
    }
    
    public func setImages(_ images: [UIImage]?, withTitle title: String, isActions: Bool) {
        actionsWithImageButton.alpha = (isActions) ? 1.0 : 0.0
        plantImages = images ?? []
        titleLabel.text = title
        collectionImageView?.reloadData()
    }
    
    fileprivate func scrollTo(_ index: Int) {
        collectionImageView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
    }
    
    @IBAction func actionsWithImageButtonTapped(_ sender: UIButton) {
        presentAddImageActionSheet()
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension PlantImageHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (plantImages.count != 0) ? plantImages.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlantImageHeaderViewCell.reuseId, for: indexPath) as! PlantImageHeaderViewCell
        let image = (plantImages.count == 0) ? #imageLiteral(resourceName: "default-plant") : plantImages[indexPath.row]
        cell.setImage(image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionImageView.frame.width, height: collectionImageView.frame.height)
    }
    
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PlantImageHeaderView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        plantImages.append(image)
        collectionImageView.reloadData()
        delegate?.addImage(image)
        delegate?.dismissView(animated: true)
        scrollTo(plantImages.count - 1)
    }
    
}
