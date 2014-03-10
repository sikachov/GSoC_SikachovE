__author__ = 'Sikachov Evgeny'

class UnaryMatrixOperation(object):
    def __init__(self,Matrix,resultFilePath="result.csv"):

        try:
            s=open (Matrix,'r')
        except IOError:
            print "No such file or directory: "

        matrix=[]
        for line in open(Matrix):
            matrix.append([int(i) for i in line.split(",")])
        self.matrix=matrix


    def Operation(self,operation):
        try:
            s=open(operation,'r')
        except IOError:
            print "No such file or directory: "
        return open(operation,'r').readline()

    def OutResult(self,string):
        r=open("result.csv","w")
        for i in string:
            r.write(str(i))
            r.write("\n")


    def trans(self,matr):
        return zip(*matr)

    def obr(self,matr):
        return 0


    def det(self,x):
        l = len(x)
        if l == 1:
            return x[0][0]
        return sum([(-1)**i*x[i][0]*self.det(self.minor(x,i+1,1)) for i in range(l)])

    def minor(self,x,i,j):
        y = x[:]
        del(y[i-1])
        y=zip(*y)
        del(y[j-1])
        return zip(*y)


    def inverse(self,matr):
        return matr







r=open("result.csv","w")

mat=UnaryMatrixOperation('matrix.csv')
oper=mat.Operation("operation.csv")
if oper=='det':
    r.write(str(mat.det(mat.matrix)))
elif oper=='T':
    mat.OutResult(mat.trans(mat.matrix))
elif oper=="-1":
    mat.OutResult(mat.inverse(mat.matrix))
r.close()
