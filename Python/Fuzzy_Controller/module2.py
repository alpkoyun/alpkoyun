from vaccination import Vaccination
import numpy as np
import matplotlib.pyplot as plt
import skfuzzy as fuzz


defuzzymethods=['mom','centroid','bisector','som','lom']#different defuzzy methods
xaxis = np.linspace(0,1,11)
xaxiscontrol=np.linspace(-0.2,0.2,9)
print(xaxis)
percentlowset  = fuzz.trapmf(xaxis,[0,0,0.4,0.6])
percentfitset = fuzz.trimf(xaxis,[0.5,0.6,0.7])
percenthighset = fuzz.trapmf(xaxis,[0.6,0.7,1,1])

lowcontrolset= fuzz.trapmf(xaxiscontrol,[-0.2,-0.2,-0.15,-0.05])
fitcontrolset= fuzz.trimf(xaxiscontrol,[-0.1,0,0.1])
highcontrolset= fuzz.trapmf(xaxiscontrol,[0.05,0.15,0.2,0.2])




#Trapmf function creates  first initialized an array with 1 in length of x2 right triangles between first-second and third-forth elements
# then function makes all the values before first element and all elements after last element 0,
# making all elements after 0.6 0 in the first function creates a trapezoid which faces right
# making all elements before 0.6 in the first function creates a trapezoid which faces left
# trimf function creates a triangle between first and last element specified with second element being top corner of triangle
fig, (ax0) = plt.subplots( figsize = (10,3))
    
ax0.plot(xaxiscontrol, lowcontrolset , 'r', linewidth = 2, label = "Low")
ax0.plot(xaxiscontrol, fitcontrolset , 'g', linewidth = 2, label = "Middle")
ax0.plot(xaxiscontrol, highcontrolset, 'b', linewidth = 2, label = "High")
ax0.set_title("Control sets")
ax0.legend()

plt.savefig("Vaccination1controlsets.jpg")## safe control sets


fig, (ax0) = plt.subplots( figsize = (10,3))
    
ax0.plot(xaxis, percentlowset , 'r', linewidth = 2, label = "Low")
ax0.plot(xaxis, percentfitset , 'g', linewidth = 2, label = "Middle")
ax0.plot(xaxis, percenthighset, 'b', linewidth = 2, label = "High")
ax0.set_title("Vaccination sets")
ax0.legend()

plt.savefig("Vaccination1percentsts.jpg")#save vaccinaion percentage sets




for method in defuzzymethods:#loop over all defuzzy methods to find best
    myvaccination=Vaccination()#create vaccination object
    reached06=0
    totalcost=0
    currentrate=0
    lastrate=0
    equ=0#equilibrium
    for x in range(200):
       
        lastrate=currentrate# update last vaccination percentage
        vaccinationpercentage, vaccinationrate = myvaccination.checkVaccinationStatus()#check vaccination status
        #controller starts here
        memberlow  = fuzz.interp_membership(xaxis, percentlowset , vaccinationpercentage)#check membership on low percentage
        memberfit  = fuzz.interp_membership(xaxis, percentfitset , vaccinationpercentage)#check membership on mid percentage
        memberhigh= fuzz.interp_membership(xaxis, percenthighset , vaccinationpercentage)#check membership on high percentage

        #rules are simple, if the percentage is low, change is high
        #cut the membership function below the membership value as we saw in class
        rule1 = np.fmin(memberlow , highcontrolset)#if the vaccination percentage is low, make vaccination rate high
        rule2 = np.fmin(memberfit , fitcontrolset )#if the vaccination percentage is near fit, make vaccination rate mid
        rule3 = np.fmin( memberhigh, lowcontrolset )#if the vaccination percentage is high, make vaccination rate low

        out = np.fmax(np.fmax(rule1,rule2),rule3)# take maks of all
        
        #defuzzify
        controlout = fuzz.defuzz(xaxiscontrol, out, method)#defuzzy with given method
        #controllerend
    
        myvaccination.vaccinatePeople(controlout)# vaccinate
        if(reached06==0):#if the equilibrum is not reached update cost and check equilibrum
         currentrate=myvaccination.vaccinated_percentage_curve_[-1]
         totalcost=totalcost+myvaccination.vaccination_rate_curve_[-1]#use -1 to access last element
         if((abs(currentrate-0.6)<0.001)and(abs(currentrate-lastrate)<0.001)):#equilibrum is reached if both the current and last rate is around 0.6
             equ=x#update equilibrum point
             reached06=1# make the flag1
   
    myvaccination.viewVaccination(point_ss = equ, vaccination_cost = totalcost, filename='vaccination1'+method)