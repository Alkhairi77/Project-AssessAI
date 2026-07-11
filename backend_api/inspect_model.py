"""
Diagnostic script: Inspect the trained model to find expected input shape.
Run from backend_api/ folder with venv activated:
  python inspect_model.py
"""
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'

import numpy as np

MODEL_PATH = os.path.join("models", "best_model_indowave.keras")

print("=" * 60)
print("Loading model:", MODEL_PATH)
print("=" * 60)

import tensorflow as tf
model = tf.keras.models.load_model(MODEL_PATH)

print("\n=== MODEL SUMMARY ===")
model.summary()

print("\n=== INPUT / OUTPUT SHAPES ===")
print("Input  shape:", model.input_shape)
print("Output shape:", model.output_shape)

print("\n=== LAYER DETAILS ===")
for i, layer in enumerate(model.layers):
    try:
        print(f"[{i:2d}] {layer.__class__.__name__:20s}  input={layer.input_shape}  output={layer.output_shape}")
    except Exception:
        print(f"[{i:2d}] {layer.__class__.__name__:20s}  (shape unavailable)")

# Identify what input shape the model expects
input_shape = model.input_shape  # e.g. (None, time_steps, n_features, channels)
print("\n=== REQUIRED MFCC CONFIG ===")
if len(input_shape) == 4:
    _, time_steps, n_features, channels = input_shape
    print(f"MAX_PAD_LEN (time steps) = {time_steps}")
    print(f"N_MFCC (features)        = {n_features}")
    print(f"Channels                 = {channels}")
elif len(input_shape) == 3:
    _, time_steps, n_features = input_shape
    print(f"MAX_PAD_LEN (time steps) = {time_steps}")
    print(f"N_MFCC (features)        = {n_features}")
else:
    print("Unexpected input shape:", input_shape)

print("\n=== DONE ===")
