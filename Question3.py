# -*- coding: utf-8 -*-
"""
Created on Sun Apr 24 02:57:37 2022

@author: AlperenKoyun
"""

import utils
from utils import part3Plots
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
num_epochs = 15
batch_size = 64
z=0;    
learning_rate = 0.01
dic=[5]
modelnames=["mlp1","mlp2","cnn3","cnn4","cnn5","mlp1s","mlp2s","cnn3s","cnn4s","cnn5s"]
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



class mlp1(nn.Module):
    def __init__(self, input_size, num_classes):
        super(mlp1, self).__init__()
        self.input_size = input_size
        self.l1 = nn.Linear(in_features=input_size,out_features=64) 
        self.relu = nn.ReLU()
        self.l2 = nn.Linear(in_features=64, out_features=10)
        

    def forward(self, x):
        out = self.l1(x)
        out = self.relu(out)
        out = self.l2(out)
        # no activation and no softmax at the end
        return out
    
class mlp2(nn.Module):
    def __init__(self, input_size, num_classes):
        super(mlp2, self).__init__()
        self.input_size = input_size
        self.l1 = nn.Linear(input_size, 16) 
        self.relu = nn.ReLU()
        self.l2=nn.Linear(16,64)
        self.l3 = nn.Linear(64, num_classes)
        

    def forward(self, x):
        out = self.l1(x)
        out = self.relu(out)
        out = self.l2(out)
        out = self.l3(out)
        # no activation and no softmax at the end
        return out
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
    
class cnn4(nn.Module):
    def __init__(self,):
        super(cnn4, self).__init__()
        self.input_size = input_size
        self.l1 = nn.Conv2d(1,16,3,padding='valid')
        self.conv2=nn.Conv2d(16,8,5,padding='valid')
        self.conv3=nn.Conv2d(8,5,3,padding='valid')
        self.conv4=nn.Conv2d(5,16,5,padding='valid')
        self.relu = nn.ReLU()
        self.pool=nn.MaxPool2d(2,2)
        self.l = nn.Linear(3*3*16, num_classes)
        

    def forward(self, x):
        out = self.l1(x)
        out = self.relu(out)
        out = self.conv2(out)
        out = self.relu(out)
        out = self.conv3(out)
        out = self.relu(out)
        out = self.pool(out)
        out = self.conv4(out)
        out = self.relu(out)
        out = self.pool(out)
        out=out.view(-1,3*3*16)
        out = self.l(out)
        # no activation and no softmax at the end
        return out

class cnn5(nn.Module):
    def __init__(self):
        super(cnn5, self).__init__()
        self.input_size = input_size
        self.l1 = nn.Conv2d(1,16,3,padding='valid')
        self.conv2=nn.Conv2d(16,8,3,padding='valid')
        self.conv3=nn.Conv2d(8,8,3,padding='valid')
        self.conv4=nn.Conv2d(8,8,3,padding='valid')
        self.conv5=nn.Conv2d(8,16,3,padding='valid')
        self.conv6=nn.Conv2d(16,16,3,padding='valid')
        
        self.relu = nn.ReLU()
        self.pool=nn.MaxPool2d(2,2)
        self.l = nn.Linear(3*3*16, num_classes)
        

    def forward(self, x):
        out = self.l1(x)#it is cov
        out = self.relu(out)
        out = self.conv2(out)
        out = self.relu(out)
        out = self.conv3(out)
        out = self.relu(out)
        out = self.conv4(out)
        out = self.relu(out)
        out = self.pool(out)
        out = self.conv5(out)
        out = self.relu(out)
        out = self.conv6(out)
        out = self.relu(out)
        out = self.pool(out)
        out=out.view(-1,3*3*16)
        out = self.l(out)
        # no activation and no softmax at the end
        return out
class mlp1s(nn.Module):
    def __init__(self, input_size, num_classes):
        super(mlp1s, self).__init__()
        self.input_size = input_size
        self.l1 = nn.Linear(in_features=input_size,out_features=64) 
        self.relu = nn.Sigmoid()
        self.l2 = nn.Linear(in_features=64, out_features=10)
        

    def forward(self, x):
        out = self.l1(x)
        out = self.relu(out)
        out = self.l2(out)
        # no activation and no softmax at the end
        return out
    
class mlp2s(nn.Module):
    def __init__(self, input_size, num_classes):
        super(mlp2s, self).__init__()
        self.input_size = input_size
        self.l1 = nn.Linear(input_size, 16) 
        self.relu = nn.Sigmoid()
        self.l2=nn.Linear(16,64)
        self.l3 = nn.Linear(64, num_classes)
        

    def forward(self, x):
        out = self.l1(x)
        out = self.relu(out)
        out = self.l2(out)
        out = self.l3(out)
        # no activation and no softmax at the end
        return out
class cnn3s(nn.Module):
    def __init__(self,):
        super(cnn3s, self).__init__()
        self.input_size = input_size
        self.l1 = nn.Conv2d(1,16,3,padding='valid')
        self.conv2=nn.Conv2d(16,8,7,padding='valid')
        self.conv3=nn.Conv2d(8,16,5,padding='valid')
        self.relu = nn.Sigmoid()
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
    
class cnn4s(nn.Module):
    def __init__(self,):
        super(cnn4s, self).__init__()
        self.input_size = input_size
        self.l1 = nn.Conv2d(1,16,3,padding='valid')
        self.conv2=nn.Conv2d(16,8,5,padding='valid')
        self.conv3=nn.Conv2d(8,5,3,padding='valid')
        self.conv4=nn.Conv2d(5,16,5,padding='valid')
        self.relu = nn.Sigmoid()
        self.pool=nn.MaxPool2d(2,2)
        self.l = nn.Linear(3*3*16, num_classes)
        

    def forward(self, x):
        out = self.l1(x)
        out = self.relu(out)
        out = self.conv2(out)
        out = self.relu(out)
        out = self.conv3(out)
        out = self.relu(out)
        out = self.pool(out)
        out = self.conv4(out)
        out = self.relu(out)
        out = self.pool(out)
        out=out.view(-1,3*3*16)
        out = self.l(out)
        # no activation and no softmax at the end
        return out

class cnn5s(nn.Module):
    def __init__(self):
        super(cnn5s, self).__init__()
        self.input_size = input_size
        self.l1 = nn.Conv2d(1,16,3,padding='valid')
        self.conv2=nn.Conv2d(16,8,3,padding='valid')
        self.conv3=nn.Conv2d(8,8,3,padding='valid')
        self.conv4=nn.Conv2d(8,8,3,padding='valid')
        self.conv5=nn.Conv2d(8,16,3,padding='valid')
        self.conv6=nn.Conv2d(16,16,3,padding='valid')
        
        self.relu = nn.Sigmoid()
        self.pool=nn.MaxPool2d(2,2)
        self.l = nn.Linear(3*3*16, num_classes)
        

    def forward(self, x):
        out = self.l1(x)#it is cov
        out = self.relu(out)
        out = self.conv2(out)
        out = self.relu(out)
        out = self.conv3(out)
        out = self.relu(out)
        out = self.conv4(out)
        out = self.relu(out)
        out = self.pool(out)
        out = self.conv5(out)
        out = self.relu(out)
        out = self.conv6(out)
        out = self.relu(out)
        out = self.pool(out)
        out=out.view(-1,3*3*16)
        out = self.l(out)
        # no activation and no softmax at the end
        return out


while(z<5):
    lossarray=[[] for i in range(2)]
    gradarray=[[] for i in range(2)]
    weigths = [[] for i in range(0,RUN)]
    test_accuracy_array = []
    print(modelnames[z])
    for j in range(0,RUN):
        for a in range(2):
            train_dataset = torchvision.datasets.FashionMNIST(root='./data', 
                                                      train=True, 
                                                      transform=data_transform,  
                                                      download=True)
            
            test_dataset = torchvision.datasets.FashionMNIST(root='./data', 
                                                      train=False, 
                                                      transform=data_transform)
            
            indic=list(range(len(train_dataset)))
            np.random.shuffle(indic)
            
            split=int(np.floor(0.1*len(train_dataset)))
            valid_data=SubsetRandomSampler(indic[:split])
            
            # Data loader
            train_loader = torch.utils.data.DataLoader(dataset=train_dataset, 
                                                      batch_size=batch_size, 
                                                      shuffle=True)
            valid_loader=torch.utils.data.DataLoader(dataset=train_dataset,sampler=valid_data, 
                                                      batch_size=batch_size)
            
            
            test_loader = torch.utils.data.DataLoader(dataset=test_dataset, 
                                                      batch_size=batch_size, 
                                                      shuffle=True)
            
            
            
            
            if(z==0):
                model = mlp1(input_size,num_classes).to(device)
            if(z==1):
                model = mlp2(input_size,num_classes).to(device)
            if(z==2):
                model = cnn3().to(device)
            if(z==3):
                model = cnn4().to(device)
            if(z==4):
                model = cnn5().to(device)
            if(z==5):
                model = mlp1s(input_size,num_classes).to(device)
            if(z==6):
                model = mlp2s(input_size,num_classes).to(device)
            if(z==7):
                model = cnn3s().to(device)
            if(z==8):
                model = cnn4s().to(device)
            if(z==9):
                model = cnn5s().to(device)
            # Fully connected neural network with one hidden layer
              
          
            total_train=0
            correct_train=0
            # Loss and optimizer
            criterion = nn.CrossEntropyLoss()
            optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate)  
            #torch.optim.SGD(model_mlp.parameters(), lr = 0.01, momentum = 0.0)
            # Train the model
            n_total_steps = len(train_loader)
            model.train()
            for epoch in range(num_epochs):
                for i, (images, labels) in enumerate(train_loader):  
                    # origin shape: [100, 1, 28, 28]
                    # resized: [100, 784]
                    if((z==0)or(z==1)):
                        images=images.reshape(-1,784)
                    images = images.to(device)
                    labels = labels.to(device)
                    with torch.no_grad():
                      weights_before = model.l1.weight.cpu().numpy()
                    # Forward pass
                    outputs = model(images)
                    loss = criterion(outputs, labels)

                    # Backward and optimize
                    optimizer.zero_grad()
                    loss.backward()
                    optimizer.step()
                    
                    if (i+1) % 10 == 0:
                        with torch.no_grad():
                            weights_after = model.l1.weight.cpu().numpy()
                            weight_diff = np.subtract(weights_before, weights_after)
                            weight_diff = np.divide(weight_diff, 0.01) 
                            weight_diff = np.linalg.norm(weight_diff)
                            weight_diff = weight_diff.tolist()
                            lossarray[a] = lossarray[a] + [loss.cpu()]
                            gradarray[a] = gradarray[a] + [weight_diff]

                            
                            print (f'epoch [{epoch+1}/{num_epochs}], Step [{i+1}/{n_total_steps}], Loss: {loss.item():.4f}')
            
            # Test the model
            # In test phase, we don't need to compute gradients (for memory efficiency
            
            
    if(z==0):
        mcdictionary1 = {
                    'name' : modelnames[z],
                    'relu_loss_curve' : lossarray[0],
                    'sigmoid_loss_curve' : lossarray[1],
                    'relu_grad_curve' : gradarray[0],
                    'sigmoid_grad_curve' : gradarray[1],
                    }
  
    if(z==1):
        mcdictionary2 = {
                    'name' : modelnames[z],
                    'relu_loss_curve' : lossarray[0],
                    'sigmoid_loss_curve' : lossarray[1],
                    'relu_grad_curve' : gradarray[0],
                    'sigmoid_grad_curve' : gradarray[1],
                    }
    
    if(z==2):
        mcdictionary3 = {
                    'name' : modelnames[z],
                    'relu_loss_curve' : lossarray[0],
                    'sigmoid_loss_curve' : lossarray[1],
                    'relu_grad_curve' : gradarray[0],
                    'sigmoid_grad_curve' : gradarray[1],
                    }
    
    if(z==3):
        mcdictionary4 = {
                    'name' : modelnames[z],
                    'relu_loss_curve' : lossarray[0],
                    'sigmoid_loss_curve' : lossarray[1],
                    'relu_grad_curve' : gradarray[0],
                    'sigmoid_grad_curve' : gradarray[1],
                    }
    
    if(z==4):
        mcdictionary5 = {
                    'name' : modelnames[z],
                    'relu_loss_curve' : lossarray[0],
                    'sigmoid_loss_curve' : lossarray[1],
                    'relu_grad_curve' : gradarray[0],
                    'sigmoid_grad_curve' : gradarray[1],
                    }
        
          
        
    lossarray.clear()
    gradarray.clear()
    z=z+1
dim=[mcdictionary1,mcdictionary2,mcdictionary3,mcdictionary4,mcdictionary5,]
part3Plots(dim, save_dir='./part3/', filename='part3Plots')