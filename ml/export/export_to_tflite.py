import tensorflow as tf
import os
from ml.train.neural_network import create_animal_chess_model
from ml.train.utils import get_num_actions

MODEL_DIR = 'ml/models'
EXPORT_DIR = 'ml/exported_models'

def export_to_tflite(model_path=None, output_name='animal_chess_model.tflite'):
    """
    Converts a trained Keras model to TensorFlow Lite format.

    Args:
        model_path (str, optional): Path to the trained Keras model (.h5 file).
                                    If None, it tries to load the latest model from MODEL_DIR.
        output_name (str, optional): Name of the output TFLite file.
    """
    if model_path is None:
        # Find the latest model in the MODEL_DIR
        model_files = [f for f in os.listdir(MODEL_DIR) if f.endswith('.h5')]
        if not model_files:
            print(f"No .h5 models found in {MODEL_DIR}. Please train a model first.")
            return
        # Sort by modification time (newest first)
        model_files.sort(key=lambda x: os.path.getmtime(os.path.join(MODEL_DIR, x)), reverse=True)
        latest_model_path = os.path.join(MODEL_DIR, model_files[0])
        print(f"Loading latest model from: {latest_model_path}")
        model = tf.keras.models.load_model(latest_model_path)
    else:
        print(f"Loading model from: {model_path}")
        model = tf.keras.models.load_model(model_path)

    # Create a converter
    converter = tf.lite.TFLiteConverter.from_keras_model(model)

    # Convert the model
    tflite_model = converter.convert()

    # Create export directory if it doesn't exist
    os.makedirs(EXPORT_DIR, exist_ok=True)

    # Save the TFLite model
    output_path = os.path.join(EXPORT_DIR, output_name)
    with open(output_path, 'wb') as f:
        f.write(tflite_model)

    print(f"Model successfully converted to TFLite and saved to: {output_path}")

if __name__ == '__main__':
    # Example usage: export the latest trained model
    export_to_tflite()