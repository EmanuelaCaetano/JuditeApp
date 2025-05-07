import Foundation
import CoreML
import SwiftUI
import Vision

/// Controle o seu CoreML
///
/// Classe que controla a relação da View com o meu Model de CoreML, todas minhas funções de relacionadas ao meu model de CoreML que serão aplicadas na view estarão aqui.
///
class CoreMLViewModel {
    
    /// Função que checa a imagem e aplica o model do CoreML
    ///
    /// - Parameters:
    ///   - image: A imagem que você quer analizar
    ///
    /// - Returns: Uma String do que o model identificou na sua imagem
    func checkImage(_ image: UIImage) -> String {
        guard let ciImage = CIImage(image: image) else {
            print("Could not convert UIImage to CIImage.")
            exit(0)
        }
        
        var classificationLabel: String = ""
        
        do {
            let config = MLModelConfiguration()
            let coreMLModel = try VNCoreMLModel(for: SignosClassifier(configuration: config).model)
            
            let request = VNCoreMLRequest(model: coreMLModel) { request, error in
                if let results = request.results as? [VNClassificationObservation] {
                    classificationLabel = results.first!.identifier
                } else {
                    print("Invalid Classify")
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            
            try? handler.perform([request])

        } catch {
            // something went wrong!
            print("Could not load model: \(error.localizedDescription)")
        }
        
        return classificationLabel
    }
    
    //func abre a camera
}

