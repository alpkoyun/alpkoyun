import utils
from utils import part4Plots
from utils import visualizeWeights
import torch
import torch.nn as nn
import torchvision
import torchvision.transforms as transforms
import matplotlib.pyplot as plt
import numpy as np
import json
import gc
from torch.utils.data.sampler import SubsetRandomSampler

# Device configuration
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
RUN=1;

# Hyper-parameters 
input_size = 784 # 28x28
hidden_size = 600 
hidden2_size=300   
hidden3_size=100
num_classes = 10
num_epochs = 30
batch_size = 64
z=0;    
learning_rate = 0.01
dic=[5]
modelnames=["mlp1","mlp2","cnn3","cnn4","cnn5","mlp1s","mlp2s","cnn3s","cnn4s","cnn5s"]
learningrates=[0.1,0.01,.001,]
# MNIST dataset 
class custom_normalize(object):
    def __init__(self, n):
      self.n = n

    def __call__(self, tensor):        
        return ((tensor*2)/self.n-1)
#transforms.ToTensor()
#data_transform=transforms.ToTensor()
data_transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize((0.5,),(0.5,))
    ])




class cnn3(nn.Module):
    def __init__(self,):
        super(cnn3, self).__init__()
        self.input_size = input_size
        self.l1 = nn.Conv2d(1,16,3,padding='valid')
        self.conv2=nn.Conv2d(16,8,7,padding='valid')
        self.conv3=nn.Conv2d(8,16,5,padding='valid')
        self.relu = nn.ReLU()
        self.pool=nn.MaxPool2d(2,2)
        self.l = nn.Linear(16*3*3, num_classes)
        

    def forward(self, x):
        out = self.l1(x)
        out = self.relu(out)
        out = self.conv2(out)
        out = self.relu(out)
        out = self.pool(out)
        out = self.conv3(out)
        out = self.pool(out)
        out = out.view(-1,16*3*3)
        out = self.l(out)
        # no activation and no softmax at the end
        return out
    
lossarray=[[] for i in range(3)]
weigths = [[] for i in range(0,RUN)]
valid_accuracy_array = [[] for i in range(3)]
    
   

train_dataset = torchvision.datasets.FashionMNIST(root='./data', 
                                          train=True, 
                                          transform=data_transform,  
                                          download=True)



indic=list(range(len(train_dataset)))
np.random.shuffle(indic)

split=int(np.floor(0.1*len(train_dataset)))
valid_data=SubsetRandomSampler(indic[:split])

# Data loader
train_loader = torch.utils.data.DataLoader(dataset=train_dataset, 
                                          batch_size=batch_size, 
                                          shuffle=True,pin_memory=True)
valid_loader=torch.utils.data.DataLoader(dataset=train_dataset,sampler=valid_data, 
                                          batch_size=batch_size,pin_memory=True)








# Fully connected neural network with one hidden layer
  
model = cnn3().to(device)
total_train=0
correct_train=0
# Loss and optimizer
criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.SGD(model.parameters(), lr=learningrates[0],momentum=0)  
#torch.optim.SGD(model_mlp.parameters(), lr = 0.01, momentum = 0.0)
# Train the model
counter=0
n_total_steps = len(train_loader)
model.train()
for epoch in range(num_epochs):
    for i, (images, labels) in enumerate(train_loader):  
        # origin shape: [100, 1, 28, 28]
        # resized: [100, 784]
        images, labels = images.to(device), labels.to(device)
        
        # Forward pass
        outputs = model(images)
        loss = criterion(outputs, labels)

        # Backward and optimize
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        counter=counter+1;
        if(counter==8000):
            for g in optimizer.param_groups:
                g['lr'] = 0.01
        if(counter==18000):
            for g in optimizer.param_groups:
                g['lr'] = 0.001
        
        if (i+1) % 10 == 0:
            n_samples=0
            n_correct=0
            model.eval()
            with torch.no_grad():
                
                for images, labels in (valid_loader):
                    images = images.to(device)
                    labels = labels.to(device)
                    outputs = model(images)
                    # max returns (value ,index)
                    _, predicted = torch.max(outputs.data, 1)
                    n_samples += labels.size(0)
                    n_correct += (predicted == labels).sum().item()

                validacc = 100.0 * n_correct / n_samples
                #lossarray[z] = lossarray[z] + [loss.cpu()]
                valid_accuracy_array[z] = valid_accuracy_array[z] + [validacc]
        if(i%100==0):
            print (f'epoch [{epoch+1}/{num_epochs}], Step [{i+1}/{n_total_steps}], Loss: {loss.item():.4f}')
            model.train()     
        

# Test the model
# In test phase, we don't need to compute gradients (for memory efficiency)









       

    #valid_accuracy_array=valid_accuracy_array.numpy()
mcdictionary1 = {
    'name' : modelnames[2],
    'loss_curve_1' : lossarray[0],
    'loss_curve_01' : lossarray[1],
    'loss_curve_001' : lossarray[2],
    'val_acc_curve_1': valid_accuracy_array[0],
    'val_acc_curve_01': valid_accuracy_array[1],
    'val_acc_curve_001': valid_accuracy_array[2]
    }

part4Plots(mcdictionary1, save_dir='./part4/', filename='part4Plots')
