# -*- coding: utf-8 -*-
"""
Spyder Editor

Khang Le
Giovanni Berrios
CSCI 4931
Final Project - Keras CNN for CAPTCHA

"""

import csv
import numpy as np
from matplotlib import pyplot as plt

from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation, Flatten
from keras.layers import Conv2D, MaxPooling2D
from keras.utils import np_utils
from keras import backend as K



#DATA GATHERING FUNCTIONS
def recall_m(y_true, y_pred):
    true_positives = K.sum(K.round(K.clip(y_true * y_pred, 0, 1)))
    possible_positives = K.sum(K.round(K.clip(y_true, 0, 1)))
    recall = true_positives / (possible_positives + K.epsilon())
    return recall

def precision_m(y_true, y_pred):
    true_positives = K.sum(K.round(K.clip(y_true * y_pred, 0, 1)))
    predicted_positives = K.sum(K.round(K.clip(y_pred, 0, 1)))
    precision = true_positives / (predicted_positives + K.epsilon())
    return precision

def f1_m(y_true, y_pred):
    precision = precision_m(y_true, y_pred)
    recall = recall_m(y_true, y_pred)
    return 2*((precision*recall)/(precision+recall+K.epsilon()))

# Read in data
dataset = []
dataset_label = []

with open('Data.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    for row in csv_reader:
        #print(row[0])
        data = (row[0], row[1], row[2], row[3], row[4])
        dataset.append(data)
    
with open('Data_Label.csv', encoding='utf-8-sig') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    for row in csv_reader:
        dataset_label.append(row)

#print(dataset_label)
Y_train = np.array(dataset_label)
#print(Y_train[0])
#print(Y_train.shape)

#class_names = ['0','1', '2', '3', '4', '5', '6', '7', '8', '9']
data_width = 5
data_height = 5

"""
#print(dataset[0])
Y_train = np.array(dataset)
print(Y_train[0])
print(Y_train.shape)
"""
#print(Y_train.shape)
#print(Y_train[:10])
Y_train = np_utils.to_categorical(Y_train, 10)
print(Y_train.shape)

dataset_new = []


i = 0
while(i < 250):
    data_new = (dataset[i], dataset[i + 1], dataset[i + 2], dataset[i + 3], dataset[i + 4])
    dataset_new.append(data_new)
    i = i + 5


#print(dataset_new[49])


X_train = np.array(dataset_new, dtype='int')

"""
print(X_train[0])
print(X_train.shape)
plt.imshow(X_train[0])
"""

X_train = X_train.reshape((X_train.shape[0], 1, data_width, data_height)).astype('float32')
print(X_train.shape)



# Define model
model = Sequential()
model.add(Conv2D(32, (1, 1), activation='relu', input_shape=(1,5,5)))
#print(model.output_shape)
model.add(Conv2D(32, (1, 1), activation='relu'))
model.add(MaxPooling2D(pool_size=(1,1)))
model.add(Dropout(0.25))
model.add(Flatten())
model.add(Dense(25, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(10, activation='softmax'))
model.compile(loss='categorical_crossentropy', optimizer='adam', metrics = ['accuracy', f1_m, precision_m, recall_m])

# Fit model
model.fit(X_train, Y_train, batch_size=25, epochs=100, verbose=0)

# Test model
loss, acc, f1, prec, rec = model.evaluate(X_train, Y_train, verbose=0)


# This is the number of the accuracy used to measure how well the network functions.
print("TRAINING RESULTS")
print("Loss is: {}".format(loss))
print("Acc is: {}%".format(acc*100))
print("F1 is: {}".format(f1))
print("Prec is: {}".format(prec))
print("Rec is: {}".format(rec))

prediction = model.predict(X_train)

'''
testVal = 0
for count in prediction:
    print(testVal, count)
    testVal = testVal + 1
'''