name = "data/crude/alpha70.csv"
        rleframe = posDomain
        featureExtraction(rleframe["SEQC"], rleframe["Flag"])  
        featureExtractionHyd(rleframe["SEQC"])
        dataToCSV(1,name)
