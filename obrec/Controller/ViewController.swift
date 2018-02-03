//
//  ViewController.swift
//  obrec
//
//  Created by Syed on 03/02/18.
//  Copyright © 2018 Syed. All rights reserved.
//

import UIKit
import Vision
import CoreML
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var imageview: UIImageView!
    let imagePicker = UIImagePickerController()
    var utterance = AVSpeechUtterance()
    let synth = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        // MARK:- Allow Siri To Add Vocabulary
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cameraPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageview.image = userImage
            guard let ciImage = CIImage(image: userImage) else {
                fatalError("image not detected")
            }
            detect(image:ciImage)
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    // MARK:- Detect Function Added Which Takes The Image and Detect the Image Using InceptionV3
    
    func detect(image:CIImage)
    {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("model not permitted")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as?[VNClassificationObservation] else
            {
                fatalError("not identified")
            }
            let firstResult = result.first
            self.navigationItem.title = String(describing: firstResult?.identifier)
    // MARK:- Audio Functionality Added
            self.utterance = AVSpeechUtterance(string: self.navigationItem.title!)
            self.utterance.rate = 0.3
            self.synth.speak(self.utterance)
            print(result)
        }
        let handler = VNImageRequestHandler(ciImage:image)
        do {
            try handler.perform([request])
            
        }catch {
            print(error)
        }
        
    }
    // MARK:- Navigation Control
    
    @IBAction func buttonP(_ sender: Any) {
        performSegue(withIdentifier: "goToCamera", sender: self)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK:- Allow Convert Text In Image to Audio
    
}

