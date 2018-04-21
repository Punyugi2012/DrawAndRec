//
//  ViewController.swift
//  DrawAndRec
//
//  Created by punyawee  on 20/4/61.
//  Copyright © พ.ศ. 2561 punyawee . All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var digitLabel: UILabel!
    
    var requests = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.digitLabel.text = ""
        self.setUpVision()
    }
    
    @IBAction func clearCanvas(_ sender: UIButton) {
        self.canvasView.clearCanvas()
    }
    
    @IBAction func recognize(_ sender: UIButton) {
        let image = UIImage(view: self.canvasView)
        let scaledImage = scaleImage(image: image, toSize: CGSize(width: 28, height: 28))
        UIImageWriteToSavedPhotosAlbum(scaledImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        let imageRequestHandler = VNImageRequestHandler(cgImage: scaledImage.cgImage!, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        }catch {
            print(error)
        }
    }
    
    func scaleImage (image: UIImage, toSize size:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func setUpVision() {
        guard let visionModel = try? VNCoreMLModel(for: MNIST().model) else {
            fatalError("can not load Vision ML Model")
        }
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
        self.requests = [classificationRequest]
    }
    
    func handleClassification (request: VNRequest, error: Error?) {
        guard let obserations = request.results else {
            print("no results")
            return
        }
        let classifications = obserations
            .compactMap({$0 as? VNClassificationObservation})
            .filter({$0.confidence > 0.8})
            .map({$0.identifier})
        DispatchQueue.main.async {
            self.digitLabel.text = classifications.first
        }
    }
    
//    @IBAction func save(_ sender: UIButton) {
//        UIGraphicsBeginImageContextWithOptions(self.canvasView.bounds.size, false, 0.0)
//        self.canvasView.drawHierarchy(in: self.canvasView.bounds, afterScreenUpdates: true)
//        let imageData = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        UIImageWriteToSavedPhotosAlbum(imageData!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//    }
//
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }


}

