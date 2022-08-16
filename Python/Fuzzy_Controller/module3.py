from vaccination import Vaccination
import numpy as np
import skfuzzy as fuzz
import matplotlib.pyplot as plt

defuzzymethods=['mom','centroid','bisector','som','lom']#different defuzzy methods
xaxis = np.linspace(0,1,11)
xaxiscontrol=np.linspace(-0.2,0.2,9)
failurex=np.linspace(-1,1,21)
print(failurex)

percentlowset  = fuzz.membership.trapmf(xaxis,[0,0,0.4,0.6])
percentfitset = fuzz.membership.trimf(xaxis,[0.5,0.6,0.7])
percenthighset = fuzz.membership.trapmf(xaxis,[0.6,0.7,1,1])

lowpcontrolset= fuzz.membership.trapmf(xaxiscontrol,[-0.2,-0.2,-0.1,-0.05])
lowcontrolset= fuzz.membership.trimf(xaxiscontrol,[-0.1,-0.05,0])
fitcontrolset= fuzz.membership.trimf(xaxiscontrol,[-0.05,0,0.05])
highcontrolset= fuzz.membership.trimf(xaxiscontrol,[0,0.05,0.1])
highpcontrolset= fuzz.membership.trapmf(xaxiscontrol,[0.05,0.1,0.2,0.2])

faillowset=fuzz.membership.trapmf(failurex,[-1,-1,-0.4,0])
failfitset=fuzz.membership.trimf(failurex,[-0.5,0,0.5])
failhighset=fuzz.membership.trapmf(failurex,[0,0.4,1,1])




#Trapmf function creates  first initialized an array with 1 in length of x2 right triangles between first-second and third-forth elements
# then function makes all the values before first element and all elements after last element 0,
# making all elements after 0.6 0 in the first function creates a trapezoid which faces right
# making all elements before 0.6 in the first function creates a trapezoid which faces left
# trimf function creates a triangle between first and last element specified with second element being top corner of triangle
fig, (ax0) = plt.subplots( figsize = (10,3))
    
ax0.plot(xaxiscontrol, lowcontrolset , 'r', linewidth = 2, label = "Low")
ax0.plot(xaxiscontrol, fitcontrolset , 'g', linewidth = 2, label = "Middle")
ax0.plot(xaxiscontrol, highcontrolset, 'b', linewidth = 2, label = "High")
ax0.plot(xaxiscontrol, highpcontrolset, 'y', linewidth = 2, label = "Highp")
ax0.plot(xaxiscontrol, lowpcontrolset, 'k', linewidth = 2, label = "lowp")
ax0.set_title("Vaccination2 Control sets")## save control sets
ax0.legend()


plt.savefig("Vaccination2control.jpg")

##############################################
fig, (ax0) = plt.subplots( figsize = (10,3))
    
ax0.plot(failurex, faillowset , 'r', linewidth = 2, label = "Low")
ax0.plot(failurex, failfitset , 'g', linewidth = 2, label = "Middle")
ax0.plot(failurex, failhighset, 'b', linewidth = 2, label = "High")
ax0.set_title("Vaccination2 failure sets")
ax0.legend()
plt.savefig("Vaccination2fail.jpg")#save failure sets
#################################

fig, (ax0) = plt.subplots( figsize = (10,3))
    
ax0.plot(xaxis, percentlowset , 'r', linewidth = 2, label = "Low")
ax0.plot(xaxis, percentfitset , 'g', linewidth = 2, label = "Middle")
ax0.plot(xaxis, percenthighset, 'b', linewidth = 2, label = "High")
ax0.set_title("Vaccination2 vaccination percentage sets")
ax0.legend()
    

plt.savefig("Vaccination2percent.jpg")#save vaccinaion percentage sets





for method in defuzzymethods:#loop over all defuzzy methods to find best
    myvaccination=Vaccination()#create vaccination object
    reached06=0#equilibrum flag
    totalcost=0
    tempcost=0
    currentrate=0
    lastrate=0
    equ=0#equilibrium number
    for x in range(200):
    
        lastrate=currentrate# update last vaccination percentage
        vaccinationpercentage, vaccinationrate = myvaccination.checkVaccinationStatus()#check vaccination status

        memberlow  = fuzz.interp_membership(xaxis, percentlowset , vaccinationpercentage)#check membership on low percentage
        memberfit  = fuzz.interp_membership(xaxis, percentfitset , vaccinationpercentage)#check membership on mid percentage
        memberhigh = fuzz.interp_membership(xaxis, percenthighset , vaccinationpercentage)#check membership on high percentage

        faillow= fuzz.interp_membership(failurex, faillowset , vaccinationrate)#check membership on low failureset
        failfit= fuzz.interp_membership(failurex, failfitset , vaccinationrate)#check membership on mid failureset
        failhigh= fuzz.interp_membership(failurex, failhighset , vaccinationrate)#check membership on high failureset
        ##Control levels
        #Rules
        controlhp=memberlow*faillow#If the Vaccination percentage is low and failure rate is low, then vaccination rate becomes very high(highp)
        controlh= np.fmax((memberlow * failfit),(memberfit*faillow))#:If the Vaccination percentage is low and failure rate is middle, or, vaccination percentage is middle and failure rate is low, then the vaccination rate is high
        controlm=np.fmax(np.fmax((memberlow*failhigh),(memberfit*failfit)),(memberhigh*faillow))#If the Vaccination percentage is low and failure rate is high, or, vaccination percentage is middle and failure rate is middle,
        #or the vaccination percentage is high and failure rate is low, then  the vaccination rate is high.

        controll=np.fmax((memberfit*failhigh),(memberhigh*failfit))#If the Vaccination percentage is middle and failure rate is high, or, vaccination percentage is high and failure rate is middle, then the vaccination rate is low
        controllp=memberhigh*failhigh#If the vaccination percentage is high and failure rate is high, then vaccination rate is very low(lowp)

        rule1 = np.fmin(controlhp , highpcontrolset)#cut the controlsets according to rules
        rule2 = np.fmin(controlh , highcontrolset )
        rule3 = np.fmin( controlm, fitcontrolset )
        rule4 = np.fmin( controll, lowcontrolset )
        rule5 = np.fmin( controllp, lowpcontrolset )

        out = np.fmax(np.fmax(rule1, rule2),np.fmax(rule3,rule4), rule5)# take the maximum of each rule to find output
    
        # defuzzify
        controlout = fuzz.defuzz(xaxiscontrol, out, method)#defuzzyfication with different methods
    
        myvaccination.vaccinatePeople(controlout)# vaccinate
        if(reached06==0):#if the equilibrum is not reached update cost and check equilibrum
         currentrate=myvaccination.vaccinated_percentage_curve_[-1]
         totalcost=totalcost+myvaccination.vaccination_rate_curve_[-1]#use -1 to access last element
         if((abs(currentrate-0.6)<0.001)and(abs(currentrate-lastrate)<0.001)):#equilibrum is reached if both the current and last rate is around 0.6
             equ=x#update equilibrum point
             reached06=1# make the flag1
   
    myvaccination.viewVaccination(point_ss = equ, vaccination_cost = totalcost, filename='vaccination2'+method)
