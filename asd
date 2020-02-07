#from config import  *
#from dataExtraction import *
import pandas as frame

############################## taking first 1000 positive and negative domains to extract features


AASeq = "GPSTWYACFILMVDEHKNQR"
HydSeq = "+*-"
classOut={}
dictio = {}
dicth = {}
dicth2 = {}
dicth3 = {}
dictiobwt = {}

dict_two = {}
#dict_three = {}

def initParams():
    #################################    Amino Acid Sequence
    for i in range(0, len(AASeq)):
            dictio[AASeq[i]] = []
    
    for i in range(0, len(AASeq)):
        for j in range(0, len(AASeq)):
            stri = AASeq[i] + AASeq[j]
            dict_two[stri] = []
           # string_n = '\'' + stri + '\':' + 'dict_two[\'' + stri + '\']'
            #string_n2 = string_n + ',' + string_n2 
        #print(string_n2)
        
    
#     for i in range(0, len(AASeq)):
#         for j in range(0, len(AASeq)):
#             for k in range(0, len(AASeq)):
#                 strii = AASeq[i] + AASeq[j] + AASeq[k]
#                 dict_three[strii] = []
                #string_nn = '\'' + strii + '\':' + 'dict_three[\'' + strii + '\']'
                #string_n3 = string_nn + ',' + string_n3   
    
    #################################    Hydropathy Sequence
    
    
    for i in range(0, len(HydSeq)):
            dicth["Hyd" +HydSeq[i]] = []
    
    for i in range(0, len(HydSeq)):
        for j in range(0, len(HydSeq)):
            stri = HydSeq[i] + HydSeq[j]
            dicth2["Hyd" + stri] = []
    
    for i in range(0, len(HydSeq)):
        for j in range(0, len(HydSeq)):
            for k in range(0, len(HydSeq)):
                strii = HydSeq[i] + HydSeq[j] + HydSeq[k]
                dicth3["Hyd" + strii] = []
    
    for i in range(0, len(AASeq)):
            dictiobwt[AASeq[i]] = []
            
            
    #####################################    Additional features
            
    classOut["out1"]=[]
    #classOut["out2"]=[]
    

##############################    20 binary features, for each amino acid x a feature representing
##############################    whether or not x is contained in the sequence
def methodCall(s,tempInt):
    if(tempInt>0):
        dictio[AASeq[s]].append(1)
    else:
        dictio[AASeq[s]].append(0)
    return;

def methodCallAlphaBin(stri,flag):
    dict_two[stri].append(flag)
    
    
def featureExtraction(TMD,Flag):
    
    
    for p in range(0,TMD.size):
        classOut["out1"].append(Flag[p])
#         if(Flag[p]==1):
#             classOut["out1"].append(Flag[p])
#             classOut["out2"].append(0)
#         else:
#             classOut["out2"].append(1)
#             classOut["out1"].append(Flag[p])
        tempString = TMD[p]
        for s in range(0,len(AASeq)):
            tempInt = tempString.count(AASeq[s])
            methodCall(s,tempInt)
            
        for r in range(0,len(AASeq)):
            for q in range(0,len(AASeq)):
                stri = AASeq[r] + AASeq[q]
                alphaCount =0
                for j in range(0,len(tempString)-1):
                    if(tempString[j]+tempString[j+1]==stri):
                        alphaCount = alphaCount+1
                if(alphaCount>0):
                    methodCallAlphaBin(stri,1)
                else:
                    methodCallAlphaBin(stri,0)
                    
        
         ######for calculating triplet
#         
#         for l in range(0,len(AASeq)):
#             for m in range(0,len(AASeq)):
#                 for n in range(0,len(AASeq)):
#                     strii = AASeq[l] + AASeq[m] + AASeq[n]
#                     for o in range(0,len(tempString)-2):
#                         if(tempString[o] + tempString[o+1] + tempString[o+2]==strii):
#                             dict_three[strii].append(1)
#                         else:
#                             dict_three[strii].append(0)
    return;
            
            
            
#############################    3 numerical features, for each hydropathy class x a feature
#############################    representing the number of occurrences of x in the sequence, divided by the
#############################    length of the sequence

def methodCallHyd(s,tempInt,len1):
    if(len1==0):
        frequency =0
    else:
        frequency = tempInt/len1
    dicth["Hyd" + HydSeq[s]].append(frequency)
    return;


def methodCallHydBin(stri,flag):
    dicth2["Hyd" + stri].append(flag)
    
def methodCallHydBin3(strii,flag):
    dicth3["Hyd" + strii].append(flag)

def featureExtractionHyd(TMD):
    for p in range(0,TMD.size):
        tempString = TMD[p]
        tempString1=list(tempString)
       
        for c in range(0,len(tempString)):
            if(tempString[c]=='G' or tempString[c]=='P' or tempString[c]=='S' or tempString[c]=='T' 
               or tempString[c]=='W' or tempString[c]=='Y' or tempString[c]=='G'):
                    tempString1[c] = '+'
            elif(tempString[c]=='A' or tempString[c]=='C' or tempString[c]=='F' or tempString[c]=='I' 
               or tempString[c]=='L' or tempString[c]=='M' or tempString[c]=='V'):
                    tempString1[c] = '*'
            elif(tempString[c]=='D' or tempString[c]=='E' or tempString[c]=='H' or tempString[c]=='K' 
               or tempString[c]=='N' or tempString[c]=='Q' or tempString[c]=='R'):
                    tempString1[c] = '-'
                    
            ######for calculating frequency
        for s in range(0,len(HydSeq)):
            tempInt = tempString1.count(HydSeq[s])
            methodCallHyd(s,tempInt,len(tempString1))
        
        
                    ######for calculating doublet

        for p in range(0,len(HydSeq)):
            for q in range(0,len(HydSeq)):
                stri = HydSeq[p] + HydSeq[q]
                hyd2count=0
                for j in range(0,len(tempString1)-1):
                    if(tempString1[j]+tempString1[j+1]==stri):
                            hyd2count = hyd2count+1
                if(hyd2count>0):
                    methodCallHydBin(stri,1)
                else:
                    methodCallHydBin(stri,0)
        
         ######for calculating triplet
        
        for l in range(0,len(HydSeq)):
            for m in range(0,len(HydSeq)):
                for n in range(0,len(HydSeq)):
                    strii = HydSeq[l] + HydSeq[m] + HydSeq[n]
                    hyd2count=0
                    for o in range(0,len(tempString1)-2):
                        if(tempString1[o] + tempString1[o+1] + tempString1[o+2]==strii):
                                hyd2count = hyd2count+1
                    if(hyd2count>0):
                        methodCallHydBin3(strii,1)
                    else:
                        methodCallHydBin3(strii,0)
                    
    return;
            
def getHydFeatures(df):
    Hyd = []
    Hyd.clear()
    for p in range(0,df['TMD'].size):
        tempString = df['TMD'][p]
        tempString1=list(tempString)
        for c in range(0,len(tempString)):
            if(tempString[c]=='G' or tempString[c]=='P' or tempString[c]=='S' or tempString[c]=='T' 
               or tempString[c]=='W' or tempString[c]=='Y' or tempString[c]=='G'):
                    tempString1[c] = '+'
            elif(tempString[c]=='A' or tempString[c]=='C' or tempString[c]=='F' or tempString[c]=='I' 
               or tempString[c]=='L' or tempString[c]=='M' or tempString[c]=='V'):
                    tempString1[c] = '*'
            elif(tempString[c]=='D' or tempString[c]=='E' or tempString[c]=='H' or tempString[c]=='K' 
               or tempString[c]=='N' or tempString[c]=='Q' or tempString[c]=='R'):
                    tempString1[c] = '-'
        Hyd.append(tempString1)
    return Hyd


# featureExtraction(posDomain)   
# print('feature Extraction without hydropathy complete') 
# featureExtractionHyd(posDomain)
# print('feature Extraction with hydropathy complete') 


def clearDict():
    for i in range(0, len(AASeq)):
            dictio[AASeq[i]].clear()
    
    for i in range(0, len(AASeq)):
        for j in range(0, len(AASeq)):
            stri = AASeq[i] + AASeq[j]
            dict_two[stri].clear()
    
           # string_n = '\'' + stri + '\':' + 'dict_two[\'' + stri + '\']'
            #string_n2 = string_n + ',' + string_n2 
        #print(string_n2)
        
    
#     for i in range(0, len(AASeq)):
#         for j in range(0, len(AASeq)):
#             for k in range(0, len(AASeq)):
#                 strii = AASeq[i] + AASeq[j] + AASeq[k]
#                 dict_three[strii] = []
                #string_nn = '\'' + strii + '\':' + 'dict_three[\'' + strii + '\']'
                #string_n3 = string_nn + ',' + string_n3   
    
    #################################    Hydropathy Sequence
    
    
    for i in range(0, len(HydSeq)):
            dicth["Hyd" +HydSeq[i]].clear()
    
    
    for i in range(0, len(HydSeq)):
        for j in range(0, len(HydSeq)):
            stri = HydSeq[i] + HydSeq[j]
            dicth2["Hyd" + stri].clear()
    
    
    for i in range(0, len(HydSeq)):
        for j in range(0, len(HydSeq)):
            for k in range(0, len(HydSeq)):
                strii = HydSeq[i] + HydSeq[j] + HydSeq[k]
                dicth3["Hyd" + strii].clear()
    
    
    for i in range(0, len(AASeq)):
            dictiobwt[AASeq[i]].clear()
        
    
    classOut["out1"].clear()
            
    
def dataToCSV(num,name):
    
    if(num == 1):
        feature = frame.DataFrame({'G':dictio['G'],'P':dictio['P'],'S':dictio['S'],'T':dictio['T'],'W':dictio['W'],
                                'Y':dictio['Y'],'A':dictio['A'],'C':dictio['C'],'F':dictio['F'],'I':dictio['I'],
                                'L':dictio['L'],'M':dictio['M'],'V':dictio['V'],'D':dictio['D'],'E':dictio['E'],
                                'H':dictio['H'],'K':dictio['K'],'N':dictio['N'],'Q':dictio['Q'],'R':dictio['R'],
                                'GR':dict_two['GR'],'GQ':dict_two['GQ'],'GN':dict_two['GN'],'GK':dict_two['GK'],'GH':dict_two['GH'],'GE':dict_two['GE'],'GD':dict_two['GD'],'GV':dict_two['GV'],'GM':dict_two['GM'],'GL':dict_two['GL'],'GI':dict_two['GI'],'GF':dict_two['GF'],'GC':dict_two['GC'],'GA':dict_two['GA'],'GY':dict_two['GY'],'GW':dict_two['GW'],'GT':dict_two['GT'],'GS':dict_two['GS'],'GP':dict_two['GP'],'GG':dict_two['GG'],
                                'PR':dict_two['PR'],'PQ':dict_two['PQ'],'PN':dict_two['PN'],'PK':dict_two['PK'],'PH':dict_two['PH'],'PE':dict_two['PE'],'PD':dict_two['PD'],'PV':dict_two['PV'],'PM':dict_two['PM'],'PL':dict_two['PL'],'PI':dict_two['PI'],'PF':dict_two['PF'],'PC':dict_two['PC'],'PA':dict_two['PA'],'PY':dict_two['PY'],'PW':dict_two['PW'],'PT':dict_two['PT'],'PS':dict_two['PS'],'PP':dict_two['PP'],'PG':dict_two['PG'],
                                'SR':dict_two['SR'],'SQ':dict_two['SQ'],'SN':dict_two['SN'],'SK':dict_two['SK'],'SH':dict_two['SH'],'SE':dict_two['SE'],'SD':dict_two['SD'],'SV':dict_two['SV'],'SM':dict_two['SM'],'SL':dict_two['SL'],'SI':dict_two['SI'],'SF':dict_two['SF'],'SC':dict_two['SC'],'SA':dict_two['SA'],'SY':dict_two['SY'],'SW':dict_two['SW'],'ST':dict_two['ST'],'SS':dict_two['SS'],'SP':dict_two['SP'],'SG':dict_two['SG'],
                                'TR':dict_two['TR'],'TQ':dict_two['TQ'],'TN':dict_two['TN'],'TK':dict_two['TK'],'TH':dict_two['TH'],'TE':dict_two['TE'],'TD':dict_two['TD'],'TV':dict_two['TV'],'TM':dict_two['TM'],'TL':dict_two['TL'],'TI':dict_two['TI'],'TF':dict_two['TF'],'TC':dict_two['TC'],'TA':dict_two['TA'],'TY':dict_two['TY'],'TW':dict_two['TW'],'TT':dict_two['TT'],'TS':dict_two['TS'],'TP':dict_two['TP'],'TG':dict_two['TG'],
                                'WR':dict_two['WR'],'WQ':dict_two['WQ'],'WN':dict_two['WN'],'WK':dict_two['WK'],'WH':dict_two['WH'],'WE':dict_two['WE'],'WD':dict_two['WD'],'WV':dict_two['WV'],'WM':dict_two['WM'],'WL':dict_two['WL'],'WI':dict_two['WI'],'WF':dict_two['WF'],'WC':dict_two['WC'],'WA':dict_two['WA'],'WY':dict_two['WY'],'WW':dict_two['WW'],'WT':dict_two['WT'],'WS':dict_two['WS'],'WP':dict_two['WP'],'WG':dict_two['WG'],
                                'YR':dict_two['YR'],'YQ':dict_two['YQ'],'YN':dict_two['YN'],'YK':dict_two['YK'],'YH':dict_two['YH'],'YE':dict_two['YE'],'YD':dict_two['YD'],'YV':dict_two['YV'],'YM':dict_two['YM'],'YL':dict_two['YL'],'YI':dict_two['YI'],'YF':dict_two['YF'],'YC':dict_two['YC'],'YA':dict_two['YA'],'YY':dict_two['YY'],'YW':dict_two['YW'],'YT':dict_two['YT'],'YS':dict_two['YS'],'YP':dict_two['YP'],'YG':dict_two['YG'],
                                'AR':dict_two['AR'],'AQ':dict_two['AQ'],'AN':dict_two['AN'],'AK':dict_two['AK'],'AH':dict_two['AH'],'AE':dict_two['AE'],'AD':dict_two['AD'],'AV':dict_two['AV'],'AM':dict_two['AM'],'AL':dict_two['AL'],'AI':dict_two['AI'],'AF':dict_two['AF'],'AC':dict_two['AC'],'AA':dict_two['AA'],'AY':dict_two['AY'],'AW':dict_two['AW'],'AT':dict_two['AT'],'AS':dict_two['AS'],'AP':dict_two['AP'],'AG':dict_two['AG'],
                                'CR':dict_two['CR'],'CQ':dict_two['CQ'],'CN':dict_two['CN'],'CK':dict_two['CK'],'CH':dict_two['CH'],'CE':dict_two['CE'],'CD':dict_two['CD'],'CV':dict_two['CV'],'CM':dict_two['CM'],'CL':dict_two['CL'],'CI':dict_two['CI'],'CF':dict_two['CF'],'CC':dict_two['CC'],'CA':dict_two['CA'],'CY':dict_two['CY'],'CW':dict_two['CW'],'CT':dict_two['CT'],'CS':dict_two['CS'],'CP':dict_two['CP'],'CG':dict_two['CG'],
                                'FR':dict_two['FR'],'FQ':dict_two['FQ'],'FN':dict_two['FN'],'FK':dict_two['FK'],'FH':dict_two['FH'],'FE':dict_two['FE'],'FD':dict_two['FD'],'FV':dict_two['FV'],'FM':dict_two['FM'],'FL':dict_two['FL'],'FI':dict_two['FI'],'FF':dict_two['FF'],'FC':dict_two['FC'],'FA':dict_two['FA'],'FY':dict_two['FY'],'FW':dict_two['FW'],'FT':dict_two['FT'],'FS':dict_two['FS'],'FP':dict_two['FP'],'FG':dict_two['FG'],
                                'IR':dict_two['IR'],'IQ':dict_two['IQ'],'IN':dict_two['IN'],'IK':dict_two['IK'],'IH':dict_two['IH'],'IE':dict_two['IE'],'ID':dict_two['ID'],'IV':dict_two['IV'],'IM':dict_two['IM'],'IL':dict_two['IL'],'II':dict_two['II'],'IF':dict_two['IF'],'IC':dict_two['IC'],'IA':dict_two['IA'],'IY':dict_two['IY'],'IW':dict_two['IW'],'IT':dict_two['IT'],'IS':dict_two['IS'],'IP':dict_two['IP'],'IG':dict_two['IG'],
                                'LR':dict_two['LR'],'LQ':dict_two['LQ'],'LN':dict_two['LN'],'LK':dict_two['LK'],'LH':dict_two['LH'],'LE':dict_two['LE'],'LD':dict_two['LD'],'LV':dict_two['LV'],'LM':dict_two['LM'],'LL':dict_two['LL'],'LI':dict_two['LI'],'LF':dict_two['LF'],'LC':dict_two['LC'],'LA':dict_two['LA'],'LY':dict_two['LY'],'LW':dict_two['LW'],'LT':dict_two['LT'],'LS':dict_two['LS'],'LP':dict_two['LP'],'LG':dict_two['LG'],
                                'MR':dict_two['MR'],'MQ':dict_two['MQ'],'MN':dict_two['MN'],'MK':dict_two['MK'],'MH':dict_two['MH'],'ME':dict_two['ME'],'MD':dict_two['MD'],'MV':dict_two['MV'],'MM':dict_two['MM'],'ML':dict_two['ML'],'MI':dict_two['MI'],'MF':dict_two['MF'],'MC':dict_two['MC'],'MA':dict_two['MA'],'MY':dict_two['MY'],'MW':dict_two['MW'],'MT':dict_two['MT'],'MS':dict_two['MS'],'MP':dict_two['MP'],'MG':dict_two['MG'],
                                'VR':dict_two['VR'],'VQ':dict_two['VQ'],'VN':dict_two['VN'],'VK':dict_two['VK'],'VH':dict_two['VH'],'VE':dict_two['VE'],'VD':dict_two['VD'],'VV':dict_two['VV'],'VM':dict_two['VM'],'VL':dict_two['VL'],'VI':dict_two['VI'],'VF':dict_two['VF'],'VC':dict_two['VC'],'VA':dict_two['VA'],'VY':dict_two['VY'],'VW':dict_two['VW'],'VT':dict_two['VT'],'VS':dict_two['VS'],'VP':dict_two['VP'],'VG':dict_two['VG'],
                                'DR':dict_two['DR'],'DQ':dict_two['DQ'],'DN':dict_two['DN'],'DK':dict_two['DK'],'DH':dict_two['DH'],'DE':dict_two['DE'],'DD':dict_two['DD'],'DV':dict_two['DV'],'DM':dict_two['DM'],'DL':dict_two['DL'],'DI':dict_two['DI'],'DF':dict_two['DF'],'DC':dict_two['DC'],'DA':dict_two['DA'],'DY':dict_two['DY'],'DW':dict_two['DW'],'DT':dict_two['DT'],'DS':dict_two['DS'],'DP':dict_two['DP'],'DG':dict_two['DG'],
                                'ER':dict_two['ER'],'EQ':dict_two['EQ'],'EN':dict_two['EN'],'EK':dict_two['EK'],'EH':dict_two['EH'],'EE':dict_two['EE'],'ED':dict_two['ED'],'EV':dict_two['EV'],'EM':dict_two['EM'],'EL':dict_two['EL'],'EI':dict_two['EI'],'EF':dict_two['EF'],'EC':dict_two['EC'],'EA':dict_two['EA'],'EY':dict_two['EY'],'EW':dict_two['EW'],'ET':dict_two['ET'],'ES':dict_two['ES'],'EP':dict_two['EP'],'EG':dict_two['EG'],
                                'HR':dict_two['HR'],'HQ':dict_two['HQ'],'HN':dict_two['HN'],'HK':dict_two['HK'],'HH':dict_two['HH'],'HE':dict_two['HE'],'HD':dict_two['HD'],'HV':dict_two['HV'],'HM':dict_two['HM'],'HL':dict_two['HL'],'HI':dict_two['HI'],'HF':dict_two['HF'],'HC':dict_two['HC'],'HA':dict_two['HA'],'HY':dict_two['HY'],'HW':dict_two['HW'],'HT':dict_two['HT'],'HS':dict_two['HS'],'HP':dict_two['HP'],'HG':dict_two['HG'],
                                'KR':dict_two['KR'],'KQ':dict_two['KQ'],'KN':dict_two['KN'],'KK':dict_two['KK'],'KH':dict_two['KH'],'KE':dict_two['KE'],'KD':dict_two['KD'],'KV':dict_two['KV'],'KM':dict_two['KM'],'KL':dict_two['KL'],'KI':dict_two['KI'],'KF':dict_two['KF'],'KC':dict_two['KC'],'KA':dict_two['KA'],'KY':dict_two['KY'],'KW':dict_two['KW'],'KT':dict_two['KT'],'KS':dict_two['KS'],'KP':dict_two['KP'],'KG':dict_two['KG'],
                                'NR':dict_two['NR'],'NQ':dict_two['NQ'],'NN':dict_two['NN'],'NK':dict_two['NK'],'NH':dict_two['NH'],'NE':dict_two['NE'],'ND':dict_two['ND'],'NV':dict_two['NV'],'NM':dict_two['NM'],'NL':dict_two['NL'],'NI':dict_two['NI'],'NF':dict_two['NF'],'NC':dict_two['NC'],'NA':dict_two['NA'],'NY':dict_two['NY'],'NW':dict_two['NW'],'NT':dict_two['NT'],'NS':dict_two['NS'],'NP':dict_two['NP'],'NG':dict_two['NG'],
                                'QR':dict_two['QR'],'QQ':dict_two['QQ'],'QN':dict_two['QN'],'QK':dict_two['QK'],'QH':dict_two['QH'],'QE':dict_two['QE'],'QD':dict_two['QD'],'QV':dict_two['QV'],'QM':dict_two['QM'],'QL':dict_two['QL'],'QI':dict_two['QI'],'QF':dict_two['QF'],'QC':dict_two['QC'],'QA':dict_two['QA'],'QY':dict_two['QY'],'QW':dict_two['QW'],'QT':dict_two['QT'],'QS':dict_two['QS'],'QP':dict_two['QP'],'QG':dict_two['QG'],
                                'RR':dict_two['RR'],'RQ':dict_two['RQ'],'RN':dict_two['RN'],'RK':dict_two['RK'],'RH':dict_two['RH'],'RE':dict_two['RE'],'RD':dict_two['RD'],'RV':dict_two['RV'],'RM':dict_two['RM'],'RL':dict_two['RL'],'RI':dict_two['RI'],'RF':dict_two['RF'],'RC':dict_two['RC'],'RA':dict_two['RA'],'RY':dict_two['RY'],'RW':dict_two['RW'],'RT':dict_two['RT'],'RS':dict_two['RS'],'RP':dict_two['RP'],'RG':dict_two['RG'],
                                'cla':classOut["out1"] })#, 'cla2':classOut["out2"]})
        feature.to_csv(name,index=False)
        
        clearDict()
        return feature
    if(num == 2):
        features = frame.DataFrame({'Hyd+':dicth['Hyd+'],'Hyd*':dicth['Hyd*'],'Hyd-':dicth['Hyd-'],
                                'Hyd++':dicth2['Hyd++'],'Hyd+*':dicth2['Hyd+*'],'Hyd+-':dicth2['Hyd+-'],
                                'Hyd*+':dicth2['Hyd*+'],'Hyd**':dicth2['Hyd**'],'Hyd*-':dicth2['Hyd*-'],
                                'Hyd-+':dicth2['Hyd-+'],'Hyd-*':dicth2['Hyd-*'],'Hyd--':dicth2['Hyd--'],
                                'Hyd+++':dicth3['Hyd+++'],'Hyd++*':dicth3['Hyd++*'],'Hyd++-':dicth3['Hyd++-'],
                                'Hyd+*+':dicth3['Hyd+*+'],'Hyd+**':dicth3['Hyd+**'],'Hyd+*-':dicth3['Hyd+*-'],
                                'Hyd+-+':dicth3['Hyd+-+'],'Hyd+-*':dicth3['Hyd+-*'],'Hyd+--':dicth3['Hyd+--'],
                                'Hyd*++':dicth3['Hyd*++'],'Hyd*+*':dicth3['Hyd*+*'],'Hyd*+-':dicth3['Hyd*+-'],
                                'Hyd**+':dicth3['Hyd**+'],'Hyd***':dicth3['Hyd***'],'Hyd**-':dicth3['Hyd**-'],
                                'Hyd*-+':dicth3['Hyd*-+'],'Hyd*-*':dicth3['Hyd*-*'],'Hyd*--':dicth3['Hyd*--'],
                                'Hyd-++':dicth3['Hyd-++'],'Hyd-+*':dicth3['Hyd-+*'],'Hyd-+-':dicth3['Hyd-+-'],
                                'Hyd-*+':dicth3['Hyd-*+'],'Hyd-**':dicth3['Hyd-**'],'Hyd-*-':dicth3['Hyd-*-'],
                                'Hyd--+':dicth3['Hyd--+'],'Hyd--*':dicth3['Hyd--*'],'Hyd---':dicth3['Hyd---'],
                                'cla':classOut["out1"]})#, 'cla2':classOut["out2"]})
        features.to_csv(name,index=False)
        clearDict()
        return features
