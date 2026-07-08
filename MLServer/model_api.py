import torch
import torch.nn as nn
from torchvision import datasets, transforms, models
from PIL import Image
import io  # For processing image bytes
import os

from flask import Flask, request, jsonify
from flask_cors import CORS

# Initialize the Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS

# Set device
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(f'Using device: {device}')

# Data directory for class names
data_path = "./"  # Adjust if necessary
train_dir = os.path.join(data_path, 'train')

# Load class names
image_datasets = {'train': datasets.ImageFolder(train_dir)}
class_names = image_datasets['train'].classes
num_classes = len(class_names)
print(f"Classes: {class_names}")

# Define the transformations (same as 'test' transforms during training)
data_transforms = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406],
                         [0.229, 0.224, 0.225])
])

# Load the trained model
model = models.resnet50()
num_ftrs = model.fc.in_features
model.fc = nn.Sequential(
    nn.Linear(num_ftrs, 256),
    nn.ReLU(),
    nn.Dropout(0.5),
    nn.Linear(256, num_classes)
)

model.load_state_dict(torch.load('trained.pth', map_location=device))
model = model.to(device)
model.eval()

# Function to load and preprocess the image
def load_image(image_bytes):
    image = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    image = data_transforms(image)
    image = image.unsqueeze(0)  # Add batch dimension
    return image

# Function to predict the class of an image from bytes
def predict_image_bytes(image_bytes):
    image = load_image(image_bytes).to(device)
    with torch.no_grad():
        outputs = model(image)
        _, preds = torch.max(outputs, 1)
        predicted_class = class_names[preds.item()]
    return predicted_class

# Define the /predict endpoint
@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400

    file = request.files['image']
    if file.filename == '':
        return jsonify({'error': 'No image selected'}), 400

    try:
        img_bytes = file.read()
        predicted_class = predict_image_bytes(img_bytes)
        return jsonify({'prediction': predicted_class})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    # Start the Flask app
    app.run(host='0.0.0.0', port=5001)
