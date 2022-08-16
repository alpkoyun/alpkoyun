import kivy
from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.widget import Widget
from kivy.uix.image import  Image
from time import sleep
from kivy.properties import StringProperty,NumericProperty,ObjectProperty,BooleanProperty
from kivy.core.text  import LabelBase
from kivy.clock import Clock
import time
from functools import partial

LabelBase.register(name="font1",fn_regular="HandyQuomteRegular-6YLLo.ttf")
class MyApp(App):
        def build(self):
            return Label(text="abi malsın")
class PongGame(Widget):
    mytext=ObjectProperty("Find Cart")
    startst=NumericProperty(1)
    myopacity=ObjectProperty(0)
    startbool=BooleanProperty(True)
    startop=NumericProperty(0)
    def changetext(self,text):
        self.mytext=text
        print(text)
    def changeopacity(op):
        print(PongGame.myopacity)
        myopacity=op
    def my_callback(self,op,dt):
        if(self.startst==1):
         self.myopacity=self.myopacity+op
         if(self.myopacity>1):
             self.startst=0
             return False
        else:
            self.myopacity=self.myopacity-op
            if(self.myopacity<0):
                self.startbool=False
                self.startop=1
                return False
    def getinp(self):
        event=Clock.schedule_interval(partial(PongGame.my_callback,self,0.1), 1)
        PongGame.changetext(self,"Cart Found")
    
    def fadeaway(self,op,dt):
        event=Clock.schedule_interval(partial(PongGame.my_callback,self,0.1), 0.1)
        pass
class LoginScreen(Widget):
    pass
class PongApp(App):
    def on_start(self):
        
        event=Clock.schedule_interval(partial(PongGame.my_callback,self.root,0.1), 0.1)

        event2=Clock.schedule_once(partial(PongGame.fadeaway,self.root,0.1),2)

        print(self.root)
    def build(self):
    
        a=PongGame()
        b=LoginScreen()
        return a

if __name__=="__main__":
    PongApp().run()
    print("deneme1")