import SwiftUI
import MetalKit



struct MetalEffectView: View {
    let image: Image
    @Binding var lightPosition: CGPoint
    @Binding var velocity: CGSize
    
    var body: some View {
        MetalEffectRepresentable(image: image, lightPosition: $lightPosition, velocity: $velocity)
    }
}

struct MetalEffectRepresentable: UIViewRepresentable {
    let image: Image
    @Binding var lightPosition: CGPoint
    @Binding var velocity: CGSize
    
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.framebufferOnly = false
        mtkView.delegate = context.coordinator
        mtkView.enableSetNeedsDisplay = true
        mtkView.preferredFramesPerSecond = 60
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.lightPosition = lightPosition
        context.coordinator.velocity = velocity
        uiView.setNeedsDisplay()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(image: image)
    }
    
    class Coordinator: NSObject, MTKViewDelegate {
        var image: Image
        var lightPosition: CGPoint = .zero
        var velocity: CGSize = .zero
        var pipelineState: MTLRenderPipelineState?
        var texture: MTLTexture?
        var vertexBuffer: MTLBuffer?
        var samplerState: MTLSamplerState?
        
        init(image: Image) {
            self.image = image
            super.init()
            setupMetal()
        }
        
        func setupMetal() {
            guard let device = MTLCreateSystemDefaultDevice(),
                  let library = device.makeDefaultLibrary(),
                  let vertexFunction = library.makeFunction(name: "vertexShader"),
                  let fragmentFunction = library.makeFunction(name: "fragmentShader") else {
                return
            }
            
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunction
            pipelineDescriptor.fragmentFunction = fragmentFunction
            pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            
            let vertexDescriptor = MTLVertexDescriptor()
            vertexDescriptor.attributes[0].format = .float2
            vertexDescriptor.attributes[0].offset = 0
            vertexDescriptor.attributes[0].bufferIndex = 0
            vertexDescriptor.attributes[1].format = .float2
            vertexDescriptor.attributes[1].offset = 8
            vertexDescriptor.attributes[1].bufferIndex = 0
            vertexDescriptor.layouts[0].stride = 16
            pipelineDescriptor.vertexDescriptor = vertexDescriptor
            
            pipelineState = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            
            if let uiImage = image.asUIImage() {
                let textureLoader = MTKTextureLoader(device: device)
                texture = try? textureLoader.newTexture(cgImage: uiImage.cgImage!, options: nil)
            }
            
            let vertices: [Float] = [
                -1, -1, 0, 1,
                 1, -1, 1, 1,
                -1,  1, 0, 0,
                 1,  1, 1, 0
            ]
            vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
            
            let samplerDescriptor = MTLSamplerDescriptor()
            samplerDescriptor.minFilter = .linear
            samplerDescriptor.magFilter = .linear
            samplerState = device.makeSamplerState(descriptor: samplerDescriptor)
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
        
        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let pipelineState = pipelineState,
                  let commandBuffer = view.device?.makeCommandQueue()?.makeCommandBuffer(),
                  let renderPassDescriptor = view.currentRenderPassDescriptor,
                  let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
                return
            }
            
            renderEncoder.setRenderPipelineState(pipelineState)
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            renderEncoder.setFragmentTexture(texture, index: 0)
            renderEncoder.setFragmentSamplerState(samplerState, index: 0)
            
            var lightPos = simd_float2(Float(lightPosition.x / view.bounds.width),
                                       Float(1 - lightPosition.y / view.bounds.height))
            renderEncoder.setFragmentBytes(&lightPos, length: MemoryLayout<simd_float2>.size, index: 0)
            
            var vel = simd_float2(Float(velocity.width / view.bounds.width),
                                  Float(-velocity.height / view.bounds.height))
            renderEncoder.setFragmentBytes(&vel, length: MemoryLayout<simd_float2>.size, index: 1)
            
            renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
            renderEncoder.endEncoding()
            
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
}

extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
