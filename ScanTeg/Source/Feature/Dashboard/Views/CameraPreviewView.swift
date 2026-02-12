//
//  BarcodeScannerView.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    class CameraPreview: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }

    func makeUIView(context: Context) -> CameraPreview {
        let view = CameraPreview()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: CameraPreview, context: Context) {
        DispatchQueue.main.async {
            uiView.videoPreviewLayer.frame = uiView.bounds
        }
    }
}
