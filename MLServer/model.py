import torch
import numpy as np
from torchvision import datasets, transforms, models
import matplotlib.pyplot as plt
from torch import nn, optim
import torch.nn.functional as F
from torch.utils.data import DataLoader, random_split
from tqdm import tqdm
import os
from sklearn.metrics import classification_report, confusion_matrix
import seaborn as sns

def main():
    # -------------
    # 1. SETUP
    # -------------
    # Set device (use GPU if available)
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f'Using device: {device}')

    # Data directories
    data_path = "./"  # Root directory containing 'train' and 'test' folders
    train_dir = os.path.join(data_path, 'train')
    test_dir = os.path.join(data_path, 'test')

    # Image transformations
    data_transforms = {
        'train': transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.RandomHorizontalFlip(),
            transforms.RandomRotation(15),
            transforms.ColorJitter(brightness=0.4, contrast=0.4, saturation=0.4),
            transforms.RandomResizedCrop(224, scale=(0.8, 1.0)),
            transforms.ToTensor(),
            transforms.Normalize([0.485, 0.456, 0.406],
                                 [0.229, 0.224, 0.225])
        ]),
        'val': transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.CenterCrop(224),
            transforms.ToTensor(),
            transforms.Normalize([0.485, 0.456, 0.406],
                                 [0.229, 0.224, 0.225])
        ]),
        'test': transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.CenterCrop(224),
            transforms.ToTensor(),
            transforms.Normalize([0.485, 0.456, 0.406],
                                 [0.229, 0.224, 0.225])
        ]),
    }

    # Original dataset from train folder
    full_train_dataset = datasets.ImageFolder(train_dir, transform=data_transforms['train'])

    # We want a train/val split from that 'train' folder
    # (Alternatively, if you have a separate folder for validation, skip this step.)
    val_ratio = 0.2
    train_size = int((1 - val_ratio) * len(full_train_dataset))
    val_size = len(full_train_dataset) - train_size
    train_dataset, val_dataset = random_split(full_train_dataset, [train_size, val_size])

    # The validation dataset should not have heavy augmentations
    # We reassign the validation transform
    val_dataset.dataset.transform = data_transforms['val']

    # Test dataset
    test_dataset = datasets.ImageFolder(test_dir, transform=data_transforms['test'])

    # DataLoaders
    batch_size = 32
    dataloaders = {
        'train': DataLoader(train_dataset, batch_size=batch_size, shuffle=True, num_workers=0),
        'val': DataLoader(val_dataset, batch_size=batch_size, shuffle=False, num_workers=0),
        'test': DataLoader(test_dataset, batch_size=batch_size, shuffle=False, num_workers=0)
    }

    # Class names and number of classes
    class_names = full_train_dataset.classes  # same as train_dataset.dataset.classes
    num_classes = len(class_names)
    print(f"Classes: {class_names}")
    print(f"Number of training images: {train_size}")
    print(f"Number of validation images: {val_size}")
    print(f"Number of test images: {len(test_dataset)}")

    # -------------
    # 2. MODEL SETUP
    # -------------
    # Load a pre-trained model (ResNet50)
    # (Replace 'pretrained=True' with the newer approach if you use modern PyTorch)
    model = models.resnet50(weights=models.ResNet50_Weights.DEFAULT)

    # Freeze all layers first
    for param in model.parameters():
        param.requires_grad = False

    # Replace the final fully connected layer
    num_ftrs = model.fc.in_features
    model.fc = nn.Sequential(
        nn.Linear(num_ftrs, 256),
        nn.ReLU(),
        nn.Dropout(0.5),
        nn.Linear(256, num_classes)
    )

    # Unfreeze the last few layers for fine-tuning
    for name, param in model.named_parameters():
        if "layer4" in name or "fc" in name:
            param.requires_grad = True

    model = model.to(device)
    print(model)

    # Define loss function and optimizer
    criterion = nn.CrossEntropyLoss()

    # Use SGD optimizer with momentum and weight decay
    optimizer = optim.SGD(filter(lambda p: p.requires_grad, model.parameters()),
                          lr=0.005, momentum=0.9, weight_decay=1e-4)

    # Learning rate scheduler
    scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=7, gamma=0.1)

    # -------------
    # 3. TRAINING FUNCTION
    # -------------
    def train_model(model, dataloaders, criterion, optimizer, scheduler, num_epochs):
        """
        Returns:
            - history: a dict containing training and validation losses and accuracies
        """
        history = {
            'train_loss': [],
            'train_acc': [],
            'val_loss': [],
            'val_acc': []
        }

        for epoch in range(num_epochs):
            print(f'Epoch {epoch+1}/{num_epochs}')
            print('-' * 30)

            # Each epoch has a training and validation phase
            for phase in ['train', 'val']:
                if phase == 'train':
                    model.train()
                else:
                    model.eval()

                running_loss = 0.0
                running_corrects = 0
                total_samples = 0

                for images, labels in tqdm(dataloaders[phase], desc=f"{phase} Epoch {epoch+1}/{num_epochs}"):
                    images = images.to(device)
                    labels = labels.to(device)

                    # Zero out the gradients
                    optimizer.zero_grad()

                    # Forward
                    with torch.set_grad_enabled(phase == 'train'):
                        outputs = model(images)
                        loss = criterion(outputs, labels)
                        _, preds = torch.max(outputs, 1)

                        # Backward + optimize only if in training phase
                        if phase == 'train':
                            loss.backward()
                            optimizer.step()

                    # Statistics
                    running_loss += loss.item() * images.size(0)
                    running_corrects += torch.sum(preds == labels.data)
                    total_samples += labels.size(0)

                epoch_loss = running_loss / total_samples
                epoch_acc = running_corrects.double() / total_samples

                if phase == 'train':
                    scheduler.step()
                    history['train_loss'].append(epoch_loss)
                    history['train_acc'].append(epoch_acc.item())
                else:
                    history['val_loss'].append(epoch_loss)
                    history['val_acc'].append(epoch_acc.item())

                print(f"{phase} Loss: {epoch_loss:.4f}, {phase} Acc: {epoch_acc:.4f}")

        return history

    # -------------
    # 4. EVALUATION FUNCTIONS
    # -------------
    def evaluate_model(model, dataloader, criterion, phase='Test'):
        """
        Evaluate the model on a given dataloader (test/val).
        Prints out overall loss and accuracy.
        Returns:
            - epoch_loss
            - epoch_acc
            - all_preds: list of predicted labels
            - all_labels: list of ground truth labels
        """
        model.eval()
        running_loss = 0.0
        running_corrects = 0
        total_samples = 0

        all_preds = []
        all_labels = []

        with torch.no_grad():
            for images, labels in tqdm(dataloader, desc=f"Evaluating {phase}"):
                images = images.to(device)
                labels = labels.to(device)
                outputs = model(images)

                loss = criterion(outputs, labels)
                _, preds = torch.max(outputs, 1)

                running_loss += loss.item() * images.size(0)
                running_corrects += torch.sum(preds == labels.data)
                total_samples += images.size(0)

                # Store for metrics
                all_preds.extend(preds.cpu().numpy().tolist())
                all_labels.extend(labels.cpu().numpy().tolist())

        epoch_loss = running_loss / total_samples
        epoch_acc = running_corrects.double() / total_samples

        print(f"{phase} Loss: {epoch_loss:.4f}, {phase} Accuracy: {epoch_acc:.4f}")
        return epoch_loss, epoch_acc, all_preds, all_labels

    # -------------
    # 5. TRAIN THE MODEL
    # -------------
    num_epochs = 15
    history = train_model(model, dataloaders, criterion, optimizer, scheduler, num_epochs)

    # -------------
    # 6. SAVE THE MODEL
    # -------------
    torch.save(model.state_dict(), 'best_model.pth')
    print('Model saved as best_model.pth')

    # -------------
    # 7. PLOTTING TRAIN/VAL CURVES
    # -------------
    # Plot the training and validation loss
    plt.figure(figsize=(12, 5))
    plt.subplot(1, 2, 1)
    plt.plot(range(1, num_epochs + 1), history['train_loss'], label='Train Loss')
    plt.plot(range(1, num_epochs + 1), history['val_loss'], label='Val Loss')
    plt.xlabel('Epochs')
    plt.ylabel('Loss')
    plt.title('Training & Validation Loss')
    plt.legend()

    # Plot the training and validation accuracy
    plt.subplot(1, 2, 2)
    plt.plot(range(1, num_epochs + 1), history['train_acc'], label='Train Acc')
    plt.plot(range(1, num_epochs + 1), history['val_acc'], label='Val Acc')
    plt.xlabel('Epochs')
    plt.ylabel('Accuracy')
    plt.title('Training & Validation Accuracy')
    plt.legend()
    plt.tight_layout()
    plt.show()

    # -------------
    # 8. FINAL TEST EVALUATION & METRICS
    # -------------
    print("Evaluating on Test Set:")
    test_loss, test_acc, test_preds, test_labels = evaluate_model(model, dataloaders['test'], criterion, phase='Test')

    # 8.1 Classification Report
    print("\nClassification Report:")
    print(classification_report(test_labels, test_preds, target_names=class_names))

    # 8.2 Confusion Matrix
    cm = confusion_matrix(test_labels, test_preds)
    plt.figure(figsize=(8, 6))
    sns.heatmap(cm, annot=True, fmt='d', cmap='Blues',
                xticklabels=class_names, yticklabels=class_names)
    plt.title('Confusion Matrix')
    plt.xlabel('Predicted')
    plt.ylabel('True')
    plt.show()

    # 8.3 Per-class accuracy
    per_class_accuracies = cm.diagonal() / cm.sum(axis=1)
    print("Per-class accuracy:")
    for cls_name, acc in zip(class_names, per_class_accuracies):
        print(f"{cls_name}: {acc:.2f}")

    # -------------
    # 9. SHOW EXAMPLES OF MODEL PREDICTIONS (OPTIONAL)
    # -------------
    # If you want to show sample predictions from the test set:
    # comment/uncomment as needed

    # def show_sample_predictions(model, dataset, num_samples=5):
    #     model.eval()
    #     fig, axes = plt.subplots(1, num_samples, figsize=(15, 5))
    #     for i in range(num_samples):
    #         idx = np.random.randint(0, len(dataset))
    #         image, label = dataset[idx]
    #
    #         # Move the image to GPU if available
    #         image_batch = image.unsqueeze(0).to(device)
    #
    #         with torch.no_grad():
    #             outputs = model(image_batch)
    #             _, pred = torch.max(outputs, 1)
    #
    #         # Convert the image tensor to numpy
    #         img = image.permute(1, 2, 0).numpy()
    #         # Unnormalize to display properly
    #         mean = np.array([0.485, 0.456, 0.406])
    #         std = np.array([0.229, 0.224, 0.225])
    #         img = std * img + mean
    #         img = np.clip(img, 0, 1)
    #
    #         axes[i].imshow(img)
    #         axes[i].set_title(f"Pred: {class_names[pred.item()]}\nTrue: {class_names[label]}")
    #         axes[i].axis('off')
    #
    #     plt.show()
    #
    # # Show sample predictions from test dataset
    # test_dataset_for_display = datasets.ImageFolder(test_dir, transform=data_transforms['test'])
    # show_sample_predictions(model, test_dataset_for_display, num_samples=5)

if __name__ == '__main__':
    main()
