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
python -m ml.train.train
```
(This script will automatically resume training from the latest checkpoint in `ml/models` if available.)

Export model for mobile:
```bash
python -m ml.export.export_to_tflite
```

## Model Architecture

The neural network takes a 7×9×2 tensor representing the board state (with player perspective) and outputs:
- **Policy Head**: 7×9×4 tensor representing move probabilities
- **Value Head**: Scalar value representing win probability

## Integration with Game

The trained model is integrated into the game through the `AnimalChessNetwork` class, which loads and uses the TensorFlow Lite model for inference during gameplay.

## Testing

To test the Animal Chess environment:
```bash
python -m ml.train.test_env
```

To test the neural network model:
```bash
python -m ml.train.test_neural_network
```

To evaluate the performance of the trained model:
```bash
python -m ml.train.evaluate_model
```