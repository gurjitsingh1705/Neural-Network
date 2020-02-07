import scipy.io as sio
import pandas as frame
from config import  *
from sklearn.utils import shuffle
# 
from runLengthEncoding import *
from LZ78 import *
from crude import *

###########################loading the data into scipy
data = sio.loadmat("data/First_400000_protein.mat")
DB = data['DB']
#j = np.random.permutation(400000)
new_DB = DB[0,:]
print(new_DB.shape)


########################## making a pandas dataframe from the original data

def dataIntoFrame():
    pd =[]
    pd1 =[]
    pd2 =[]
    pd3 =[]
    pd4 =[]
    for i in range(0,400000):
        pd.append(new_DB[i][0][0])
        pd1.append(new_DB[i][1][0])
        pd2.append(new_DB[i][2][0])
        pd3.append(new_DB[i][3][0])
        pd4.append(new_DB[i][4][:]) 
    return frame.DataFrame({'ID':pd, 'Length':pd1, 'TM':pd2, 'SEQ':pd3,'TM_SEQ':pd4})
    #print(dataf['TM_SEQ'])
    

#################################   method to truncate sequence
