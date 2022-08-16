# -*- coding: utf-8 -*-
"""
Created on Sun Apr 10 00:46:39 2022

@author: AlperenKoyun
"""
from utils import part2Plots
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
num_epochs = 1
batch_size = 64
z=0;    
learning_rate = 0.01
dic=[5]
modelnames=["mlp1","mlp2","cnn3","cnn4","cnn5"]
 
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
    ])# transforms for scalng



class mlp1(nn.Module):#define networks
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
        out = out.view(-1,16*3*3)#resize for lineary layer
        out = self.l(out)
        
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
        
        return out

class cnn5(nn.Module):#cnn5 module
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
        
        return out



while(z<5):# run for each model
    training_loss_array = [[] for i in range(0,RUN)]
    training_accuracy_array = [[] for i in range(0,RUN)]
    valid_accuracy_array = [[] for i in range(0,RUN)]
    weigths = [[] for i in range(0,RUN)]
    test_accuracy_array = []
    print(modelnames[z])
    for j in range(0,RUN):# run RUN times
        train_dataset = torchvision.datasets.FashionMNIST(root='./data', 
                                                   train=True, 
                                                   transform=data_transform,  
                                                   download=True)
        
        test_dataset = torchvision.datasets.FashionMNIST(root='./data', 
                                                  train=False, 
                                                  transform=data_transform)
        # make validation sampler
        indic=list(range(len(train_dataset)))
        np.random.shuffle(indic)
        
        split=int(np.floor(0.1*len(train_dataset)))
        valid_data=SubsetRandomSampler(indic[:split])
        
        # Data loaders
        train_loader = torch.utils.data.DataLoader(dataset=train_dataset, 
                                                   batch_size=batch_size, 
                                                   shuffle=True)
        valid_loader=torch.utils.data.DataLoader(dataset=train_dataset,sampler=valid_data, 
                                                  batch_size=batch_size)
        
        
        test_loader = torch.utils.data.DataLoader(dataset=test_dataset, 
                                                  batch_size=batch_size, 
                                                  shuffle=True)
        
        
        
        # select model
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
        
        # Fully connected neural network with one hidden layer
          
       
        total_train=0
        correct_train=0
        # Loss and optimizer
        criterion = nn.CrossEntropyLoss()
        optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate)  
        #torch.optim.SGD(model_mlp.parameters(), lr = 0.01, momentum = 0.0)
        # Train the model
        model.train()
        n_total_steps = len(train_loader)
        for epoch in range(num_epochs):
            for i, (images, labels) in enumerate(train_loader):  
                # origin shape: [100, 1, 28, 28]
                # resized: [100, 784]
                if((z==0)or(z==1)):
                    images=images.reshape(-1,784)
                images = images.to(device)
                labels = labels.to(device)
                
                # Forward pass
                outputs = model(images)
                loss = criterion(outputs, labels)
                _, predicted = torch.max(outputs.data, 1)
                total_train += labels.size(0)
                #take the number of correct prediction for train acc
                correct_train += (predicted == labels).sum().item()
            
                # Backward and optimize
                optimizer.zero_grad()
                loss.backward()
                optimizer.step()
                
                if (i+1) % 10 == 0:
                    model.eval()
                    with torch.no_grad():
                        n_correct = 0
                        n_samples = 0#valid evaluation
                        for images, labels in (valid_loader):
                            if((z==0)or(z==1)):
                                images=images.reshape(-1,784)
                            images = images.to(device)
                            labels = labels.to(device)
                            outputs = model(images)
                            # max returns (value ,index)
                            _, predicted = torch.max(outputs.data, 1)
                            n_samples += labels.size(0)
                            n_correct += (predicted == labels).sum().item()
                        validacc = 100.0 * n_correct / n_samples
                        #calculate train and valid accuracy
                        
                    train_accuracy = 100 * correct_train / total_train
                    training_loss_array[j] = training_loss_array[j] + [loss.cpu()]
                    training_accuracy_array[j] = training_accuracy_array[j] + [train_accuracy]
                    valid_accuracy_array[j]=valid_accuracy_array[j]+[validacc]
                    total_train=0;
                    model.train()
                    correct_train=0
                    print (f'epoch [{epoch+1}/{num_epochs}], Step [{i+1}/{n_total_steps}], Loss: {loss.item():.4f}')
        
        # Test the model
        
        model.eval()#take to final test
        with torch.no_grad():
            n_correct = 0
            n_samples = 0#eval
            for images, labels in test_loader:
                if((z==0)or(z==1)):
                    images=images.reshape(-1,784)
                images = images.to(device)
                labels = labels.to(device)
                outputs = model(images)
                # max returns (value ,index)
                _, predicted = torch.max(outputs.data, 1)
                n_samples += labels.size(0)
                n_correct += (predicted == labels).sum().item()
        
            testacc = 100.0 * n_correct / n_samples
        test_accuracy_array=test_accuracy_array+[testacc]
        print(training_accuracy_array[0])
       
        weigth=model.l1.weight.cpu().data.numpy()
        weigths[j] = weigths[j] + [weigth]
        
    with torch.no_grad():    
        training_loss_arrayy=np.array(training_loss_array)
        best_test_acc = 0
        best_test_acc_index = 0#take best accuracy
        for i in range (0, len(test_accuracy_array)):
            if (test_accuracy_array[i] > best_test_acc):
                best_test_acc = test_accuracy_array[i]
                best_test_acc_index = i
        
        #take  mean of accuracy and loss
        valid_accuracy = [ sum(x) for x in zip(*valid_accuracy_array) ]
        valid_accuracy = [element/float(RUN) for element in valid_accuracy]
        
        training_loss = [ sum(x) for x in zip(*training_loss_array) ]
        training_loss = [element/float(RUN) for element in training_loss]
        
        training_accuracy = [ sum(x) for x in zip(*training_accuracy_array) ]
        training_accuracy = [element/float(RUN) for element in training_accuracy]
        
        training_loss=np.squeeze(training_loss)
       
        
        ## create a dictionary for each model
        if(z==0):
            mcdictionary1 = {
                        'name' : modelnames,
                        'loss_curve' : training_loss,
                        'train_acc_curve' : training_accuracy,
                        'val_acc_curve' : valid_accuracy,
                        'test_acc' : best_test_acc,
                        'weigths' : weigths[best_test_acc_index]
                        }
       
        if(z==1):
            mcdictionary2 = {
                        'name' : modelnames[z],
                        'loss_curve' : training_loss,
                        'train_acc_curve' : training_accuracy,
                        'val_acc_curve' : valid_accuracy,
                        'test_acc' : best_test_acc,
                        'weigths' : weigths[best_test_acc_index]
                        }
        
        if(z==2):
            mcdictionary3 = {
                        'name' : modelnames[z],
                        'loss_curve' : training_loss,
                        'train_acc_curve' : training_accuracy,
                        'val_acc_curve' : valid_accuracy,
                        'test_acc' : best_test_acc,
                        'weigths' : weigths[best_test_acc_index]
                        }
        
        if(z==3):
            mcdictionary4 = {
                        'name' : modelnames[z],
                        'loss_curve' : training_loss,
                        'train_acc_curve' : training_accuracy,
                        'val_acc_curve' : valid_accuracy,
                        'test_acc' : best_test_acc,
                        'weigths' : weigths[best_test_acc_index]
                        }
        
        if(z==4):
            mcdictionary5 = {
                        'name' : modelnames[z],
                        'loss_curve' : training_loss,
                        'train_acc_curve' : training_accuracy,
                        'val_acc_curve' : valid_accuracy,
                        'test_acc' : best_test_acc,
                        'weigths' : weigths[best_test_acc_index]
                        }
       
        weg = weigths[best_test_acc_index]
        weg = np.array(weg)
        weg=np.squeeze(weg)
        
        
       
        #visualize weights
        visualizeWeights(weg, save_dir='./part2/', filename='weigth_'+modelnames[z]) 
        
        #clear array content for other model
        training_loss_array.clear()
        training_accuracy_array.clear()
        valid_accuracy_array.clear()
        weigths.clear()
        test_accuracy_array.clear()
        z=z+1
        #create dictionary list
dim=[mcdictionary1,mcdictionary2,mcdictionary3,mcdictionary4,mcdictionary5]
part2Plots(dim, save_dir='./part3/', filename='part2Plots')
#create plots   

    

