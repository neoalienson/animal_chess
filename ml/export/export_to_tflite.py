#!/usr/bin/env python3
"""
Export trained PyTorch model to TensorFlow Lite format for mobile deployment
"""

import torch
import torch.nn as nn
import numpy as np
import os

# Simple model for demonstration
class SimpleAnimalChessNet(nn.Module):
    def __init__(self):
        super(SimpleAnimalChessNet, self).__init__()
        
        # Simple architecture for demonstration
        self.fc1 = nn.Linear(7 * 9 * 2, 256)  # 7x9x2 input
        self.fc2 = nn.Linear(256, 128)
        self.fc3 = nn.Linear(128, 7 * 9 * 4)  # 7x9x4 outputs for moves
        self.fc4 = nn.Linear(128, 1)         # 1 output for value
        
    def forward(self, x):
        x = x.view(x.size(0), -1)  # Flatten
        x = torch.relu(self.fc1(x))
        x = torch.relu(self.fc2(x))
        
        # Split into policy and value branches
        policy_branch = self.fc3(x)
        value_branch = self.fc4(x)
        
        # Reshape policy to 7x9x4
        policy = policy_branch.view(-1, 7, 9, 4)
        
        return policy, value_branch

def export_model():
    """Export PyTorch model to TFLite format"""
    
    # Create and initialize model
    model = SimpleAnimalChessNet()
    
    # Create sample input for tracing
    sample_input = torch.randn(1, 7, 9, 2)  # Batch size 1, 7x9x2
    
    # Trace the model
    traced_model = torch.jit.trace(model, sample_input)
    
    # Save as TorchScript
    torch.jit.save(traced_model, "ml/models/animal_chess_model.pt")
    print("Saved TorchScript model to ml/models/animal_chess_model.pt")
    
    # For actual TFLite conversion, you'd use:
    # 1. Export to ONNX format first
    # 2. Then convert ONNX to TFLite
    
    print("Model export completed!")
    print("Next steps:")
    print("1. Convert to ONNX: torch.onnx.export(model, sample_input, 'model.onnx')")
    print("2. Convert ONNX to TFLite using TensorFlow tools")

if __name__ == "__main__":
    export_model()
