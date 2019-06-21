from __future__ import print_function
import tensorflow as tf
import numpy as np
# Parameters


class MLP:
    
    def __init__(self,iLen, hLen, hLen2, oLen, learningRate):
        self.NN = self.NN_intializer(iLen,hLen,hLen2,oLen)
        self.X = tf.placeholder("float32", [None, iLen],name = "X")
        self.Y = tf.placeholder("float32", [None, oLen],name = "Y")
        self.lRate = learningRate
        
    
    def NN_intializer(self,iLen,hLen,hLen2,oLen):
        weight1 = tf.Variable(tf.random_normal([iLen, hLen],stddev=0.5))
        weight2 = tf.Variable(tf.random_normal([hLen, hLen2],stddev=0.5))
        weight3 = tf.Variable(tf.random_normal([hLen2, oLen],stddev=0.5))
        
        bias1= tf.Variable(tf.zeros([hLen]))
        bias2= tf.Variable(tf.zeros([hLen2]))
        bias3= tf.Variable(tf.zeros([oLen]))
        model = {'weight1' : weight1, 'weight2':weight2, 'weight3':weight3, 'bias1':bias1, 'bias3':bias3, 'bias2':bias2}
        return model
    
    

    def propagate(self,input):
        act_relu1 = tf.nn.leaky_relu(tf.add(tf.matmul(self.X,self.NN['weight1']),self.NN['bias1']))
        activation1 = tf.nn.dropout(act_relu1,rate=0.1)
        act_relu2 = tf.nn.leaky_relu(tf.add(tf.matmul(activation1,self.NN['weight2']),  self.NN['bias2']))
        activation2 = tf.nn.dropout(act_relu2,rate=0.1)
        activation3 = tf.nn.sigmoid(tf.add(tf.matmul(activation2,self.NN['weight3']),  self.NN['bias3']),name = "logits")
        return activation3
   
        
    def train(self,input,output,epochs,test_x,test_y):
        
        logits = self.propagate(self.X)
        cost = tf.reduce_mean(tf.nn.sigmoid_cross_entropy_with_logits (logits=logits, labels=self.Y),name="cost")
        
        optimizer = tf.train.AdamOptimizer(self.lRate).minimize(cost)
        init = tf.global_variables_initializer()
        preds = tf.equal(tf.round(logits), self.Y)
        accuracy = tf.reduce_mean(tf.cast(preds, tf.float32))
        saver = tf.train.Saver()
        with tf.Session() as session:
            
            session.run(init)
            avg_cost=0
            for epoch in range(epochs):
                loss, _, acc = session.run([cost, optimizer, accuracy],feed_dict={self.X:input.eval(),self.Y:output.eval()})
                if epoch % 50 == 0:
                    print("Step: {:5}\tLoss: {:.3f}\tAcc: {:.2%}".format(epoch, loss, acc))
                
            saved_saver = saver.save(session,"tensor/layer1")
            tf.add_to_collection("logits", logits)
            print('model saved in {}'.format(saved_saver))            
            print("Accuracy: ", accuracy.eval({self.X:test_x.eval(),self.Y:test_y.eval()}))
            logi = session.run([tf.round(logits)], feed_dict = {self.X:test_x.eval()})
                    
        return logi,self.NN
    
