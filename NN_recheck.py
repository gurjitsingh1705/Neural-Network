from __future__ import print_function
import tensorflow as tf
import numpy as np
# Parameters

training_epochs = 1000
batch_size = 100
display_step = 1

class MLP:
    
    def __init__(self,iLen, hLen, hLen2, oLen, learningRate):
        self.NN = self.NN_intializer(iLen,hLen,hLen2,oLen)
        self.lRate = learningRate
    
    
    def NN_intializer(self,iLen,hLen,hLen2,oLen):
        weight1 = np.random.randn(iLen, hLen) * np.sqrt(2/hLen)
        weight2 = np.random.randn(hLen, hLen2) * np.sqrt(2/hLen2)
        weight3 = np.random.randn(hLen2, oLen) * np.sqrt(2/oLen)
        
        bias1= np.zeros((1,hLen))
        bias2= np.zeros((1,hLen2))
        bias3= np.zeros((1,oLen))
    
        model = {'weight1' : weight1, 'weight2':weight2, 'weight3':weight3, 'bias1':bias1, 'bias3':bias3, 'bias2':bias2}
        return model
    
    def tanh(self,x):
        return np.tanh(x)

    def tanh_deriv(self,x):
        return 1.0 - np.tanh(x)**2

    def relu(self, z):
        return np.maximum(0,z)
    
    def relu_derivative(self, z):
        return np.heaviside(z, 0)
    
    def softmax(self,x):
            exp = np.exp(x)
            return exp/np.sum(exp, axis=1, keepdims=True)
        
    def sigmoid(self,x,deriv=False):
        if(deriv==True):
            return (x*(1-x))
      
        return 1/(1+np.exp(-x))
    
    
    def leaky_relu(self,z):
        return np.maximum(0.01 * z, z)

    def feedForward(self,NN,input):
        activation1 = self.leaky_relu(input.dot(NN['weight1'])+  NN['bias1'])
        activation2 = self.leaky_relu(activation1.dot(NN['weight2'])+ NN['bias2'])
        activation3 = self.relu_derivative((activation2.dot(NN['weight3']) +  NN['bias3']))#,False)
        stepParams = { 'activation1':activation1,  'activation2':activation2, 'activation3':activation3}
        return stepParams
   
    def backPropagate(self,input,output,logits):
        
        
        weight1=  self.NN['weight1']
        weight2=  self.NN['weight2'] 
        weight3=  self.NN['weight3'] 
        bias1=     self.NN['bias1']
        bias2=    self.NN['bias2']
        bias3=    self.NN['bias3']
        activation1=  logits['activation1']
        activation2=  logits['activation2'] 
        activation3=  logits['activation3']
        #loss calculation
        loss3= activation3- output
        nOut  = output.shape[0]

        dWeight3 = 1/nOut *  (activation2.T).dot(loss3 )
        dBias3 = 1/nOut * np.sum(loss3, axis=0, keepdims=True)
          
        loss2 = np.multiply(loss3.dot(weight3.T), self.relu_derivative(activation2))
        dWeight2 = 1/nOut * (activation1.T).dot(loss2)
        dBias2 = 1/nOut * np.sum(loss2, axis=0, keepdims=True)
        
        loss1 = np.multiply(loss2.dot(weight2.T), self.relu_derivative(activation1))
        dWeight1 = 1/nOut *   (input.T).dot(loss1)
        dBias1 = 1/nOut * np.sum(loss1, axis=0, keepdims=True)
        #print(loss)
        

        weight1 = weight1 - self.lRate * dWeight1
        weight2 = weight2 - self.lRate * dWeight2
        weight3 = weight3 - self.lRate * dWeight3
        bias1 = bias1 - self.lRate * dBias1
        bias2 = bias2 - self.lRate * dBias2
        bias3 = bias3 - self.lRate * dBias3
        
        return  {'weight1' : weight1, 'weight2':weight2, 'weight3':weight3, 'bias1':bias1, 'bias3':bias3, 'bias2':bias2}
        #print( self.NN)   
        
    def train(self,input,output,epochs):
        #print(self.NN)
        for iterations in range(epochs):
            logits = self.feedForward(self.NN,input)
            self.NN = self.backPropagate(input,output,logits)
            print(iterations)
        #print(logits['activation3'])
        return logits,self.NN
    
    def NN_testing(self,NN,inputdf,output_te):
        stepParams = self.feedForward(NN,inputdf)
        activation3 = stepParams['activation3']
        print(activation3)
        return activation3

   