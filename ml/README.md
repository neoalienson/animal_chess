# Animal Chess Machine Learning

This directory contains the machine learning components for the Animal Chess game, including training scripts and model export utilities.

## Directory Structure

```
ml/
├── train/              # Training scripts
│   ├── train.py        # Main training script
│   └── self_play.py    # Self-play generation
├── export/             # Model export utilities
│   └── export_to_tflite.py  # Export to TensorFlow Lite
├── config/             # Training configurations
│   └── training_config.yaml
├── models/             # Trained models (will be created during training)
├── requirements.txt    # Python dependencies
└── README.md           # This file
```

## Training Process

1. **Prepare Data**: Collect game records from human players or self-play
2. **Train Model**: Run the training script
3. **Export Model**: Convert the trained model to TensorFlow Lite format for mobile deployment

## Quick Start

Install dependencies:
```bash
pip install -r ml/requirements.txt
```

Run training:
```bash
python ml/train/train.py --epochs 10 --samples 5000
```

Export model for mobile:
```bash
python ml/export/export_to_tflite.py
```

## Model Architecture

The neural network takes a 7×9×2 tensor representing the board state (with player perspective) and outputs:
- **Policy Head**: 7×9×4 tensor representing move probabilities
- **Value Head**: Scalar value representing win probability

## Integration with Game

The trained model is integrated into the game through the `AnimalChessNetwork` class, which loads and uses the TensorFlow Lite model for inference during gameplay.
