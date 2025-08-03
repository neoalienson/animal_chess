#!/usr/bin/env python3
"""
Main training script for Animal Chess ML model
"""

import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
import numpy as np
import os
import argparse

# Define the model architecture
class AnimalChessNet(nn.Module):
    def __init__(self):
        super(AnimalChessNet, self).__init__()
        
        # Input: 7x9x2 tensor (board state + player perspective)
        # Output: 7x9x4 moves + 1 value
        
        # Convolutional layers for feature extraction
        self.conv1 = nn.Conv2d(2, 32, kernel_size=3, padding=1)
        self.conv2 = nn.Conv2d(32, 64, kernel_size=3, padding=1)
        self.conv3 = nn.Conv2d(64, 128, kernel_size=3, padding=1)
        
        # Fully connected layers
        self.fc1 = nn.Linear(128 * 7 * 9, 512)
        self.fc2 = nn.Linear(512, 256)
        
        # Policy head (7x9x4 moves)
        self.policy_head = nn.Linear(256, 7 * 9 * 4)
        
        # Value head (scalar win probability)
        self.value_head = nn.Linear(256, 1)
        
    def forward(self, x):
        # x shape: (batch_size, 2, 7, 9)
        batch_size = x.size(0)
        
        # Convolutional feature extraction
        x = F.relu(self.conv1(x))
        x = F.relu(self.conv2(x))
        x = F.relu(self.conv3(x))
        
        # Flatten for fully connected layers
        x = x.view(batch_size, -1)
        
        # Shared fully connected layers
        x = F.relu(self.fc1(x))
        x = F.dropout(x, p=0.3)
        x = F.relu(self.fc2(x))
        x = F.dropout(x, p=0.3)
        
        # Policy output (7x9x4 moves)
        policy = self.policy_head(x)
        policy = policy.view(batch_size, 7, 9, 4)
        
        # Value output (win probability)
        value = torch.tanh(self.value_head(x))
        
        return policy, value

def train_model():
    """Train the model"""
    print("Starting training...")
    
    # Create model
    model = AnimalChessNet()
    
    # Loss functions
    policy_loss_fn = nn.KLDivLoss(reduction='batchmean')
    value_loss_fn = nn.MSELoss()
    
    # Optimizer
    optimizer = optim.Adam(model.parameters(), lr=0.001, weight_decay=1e-5)
    
    # Sample training data (in a real implementation, this would come from game records)
    train_data = []
    for i in range(1000):
        # Generate random board state (7x9x2)
        board_state = np.random.rand(2, 7, 9).astype(np.float32)
        
        # Generate random move probabilities (7x9x4)
        move_probs = np.random.rand(7, 9, 4).astype(np.float32)
        move_probs = move_probs / np.sum(move_probs)  # Normalize
        
        # Generate random value (win probability)
        value = np.random.rand().astype(np.float32)
        
        train_data.append((board_state, move_probs, value))
    
    # Training loop
    num_epochs = 5
    batch_size = 32
    
    for epoch in range(num_epochs):
        print(f"Epoch {epoch+1}/{num_epochs}")
        
        # Shuffle data
        np.random.shuffle(train_data)
        
        total_loss = 0.0
        num_batches = 0
        
        for i in range(0, len(train_data), batch_size):
            batch = train_data[i:i+batch_size]
            
            # Prepare batch
            board_states = torch.tensor([item[0] for item in batch], dtype=torch.float32)
            target_policies = torch.tensor([item[1] for item in batch], dtype=torch.float32)
            target_values = torch.tensor([[item[2]] for item in batch], dtype=torch.float32)
            
            # Forward pass
            optimizer.zero_grad()
            predicted_policy, predicted_value = model(board_states)
            
            # Calculate losses
            policy_loss = policy_loss_fn(
                F.log_softmax(predicted_policy.view(-1, 4), dim=1),
                F.softmax(target_policies.view(-1, 4), dim=1)
            )
            value_loss = value_loss_fn(predicted_value, target_values)
            
            # Combined loss
            loss = policy_loss + value_loss
            
            # Backward pass
            loss.backward()
            optimizer.step()
            
            total_loss += loss.item()
            num_batches += 1
            
        avg_loss = total_loss / num_batches
        print(f"Average loss: {avg_loss:.4f}")
    
    # Save model
    save_path = "ml/models/animal_chess_model.pth"
    os.makedirs(os.path.dirname(save_path), exist_ok=True)
    torch.save(model.state_dict(), save_path)
    print(f"Model saved to {save_path}")
    
    return model

def main():
    parser = argparse.ArgumentParser(description='Train Animal Chess ML model')
    parser.add_argument('--epochs', type=int, default=5, help='Number of training epochs')
    parser.add_argument('--samples', type=int, default=1000, help='Number of training samples')
    
    args = parser.parse_args()
    
    print("Animal Chess ML Training")
    print("=" * 30)
    
    model = train_model()
    
    print("\nTraining completed!")

if __name__ == "__main__":
    main()
