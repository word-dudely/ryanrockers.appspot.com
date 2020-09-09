#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
import webapp2
#import StringIO
#from google.appengine.api import images
#from PIL import Image, ImageDraw, ImageFont

with open('index.html', 'r') as index_html:
    index_html_string=index_html.read()
with open('CookingCrazeSushiPlayable.html', 'r') as CC_Playable_html:
    CC_Playable_html_string=CC_Playable_html.read()
with open('match3Dog.html', 'r') as match3Dog_html:
    match3Dog_html_string=match3Dog_html.read()
with open('randomRedditbot.html', 'r') as randomRedditbot_html:
    randomRedditbot_html_string=randomRedditbot_html.read()

#Main pages
class MainHandler(webapp2.RequestHandler):
    def get(self):		
        self.response.write(index_html_string)

#Animations

class GoAroundAnim (webapp2.RequestHandler):
    def get(self):
        self.redirect("https://drive.google.com/file/d/0B-swctkKyxQMdGRua0pMQlpiNk0/preview")
	
class SmartDogAnim (webapp2.RequestHandler):
    def get(self):
        self.redirect("https://drive.google.com/file/d/0B-swctkKyxQMTnF5cXBoUHNVV28/preview")
class EM_CharSelectAnim (webapp2.RequestHandler):
    def get(self):
        self.redirect("https://www.youtube.com/embed/bNC0WhVmpF4")
class EM_GameOnDeviceAnim (webapp2.RequestHandler):
    def get(self):
        self.redirect("https://www.youtube.com/embed/t07cZdBIwKU")
class KnittensAnim(webapp2.RequestHandler):
    def get(self):
        self.redirect("https://www.youtube.com/embed/QhaFDs4P0z4")
class TSD_CinemagraphAnim(webapp2.RequestHandler):
    def get(self):
        self.redirect("https://www.youtube.com/embed/vZzyOvVh-yQ")
class TSD_CharactersAnim(webapp2.RequestHandler):
    def get(self):
        self.redirect("https://www.youtube.com/embed/ybgwdxn9jyU")
class LOTW_PreviewAnim(webapp2.RequestHandler):
    def get(self):
        self.redirect("https://www.youtube.com/embed/whpjwwkCHTc")      
class CC_PlayableAnim(webapp2.RequestHandler):
    def get(self):
        self.response.write(CC_Playable_html_string)  
        
#Games

class Match3DogGame (webapp2.RequestHandler):
    def get(self):
        self.response.write(match3Dog_html_string)
        
class BabyDaddyGame (webapp2.RequestHandler):
    def get(self):
        self.redirect("https://drive.google.com/uc?export=download&id=0B-swctkKyxQMQXltN2hFb0JXMnc")
        
#WebApps

class RandomRedditbotApp (webapp2.RequestHandler):
    def get(self):
        self.response.write(randomRedditbot_html_string)
        
class imageTest (webapp2.RequestHandler):
    def get(self):
        #img=images.Image("images/babyDaddy_screenshot.jpg")
        #img.resize(width=1024, height=768)
        #thumbnail = img.execute_transforms(output_encoding=images.JPEG)

        #self.response.headers['Content-Type'] = 'image/jpeg'
        #self.response.out.write(thumbnail)
        #text_img = Image.new('RGBA', (800,600), (0, 0, 0, 1000))
        #draw = ImageDraw.Draw(text_img)
        #draw.text((0, 0), 'god damn', font=ImageFont.load_default())

        #output = StringIO.StringIO()
        #text_img.save(output, format="png")
        #text_layer = output.getvalue()
        #output.close()

        #self.response.headers['Content-Type'] = 'image/png'
        #self.response.write(text_layer)
        
        #im = Image.open("images/babyDaddy_screenshot.jpg")
        #im.show()
        
        self.redirect("images/babyDaddy_screenshot.jpg")

app = webapp2.WSGIApplication([
#Main Pages
    ('/', MainHandler),
    ('/images', MainHandler),
    ('/animation', MainHandler),
    ('/games', MainHandler),
    ('/contact', MainHandler),
#Animations
    ('/goAround', GoAroundAnim),
    ('/coffee', MainHandler),
    ('/dogVisitsUtah', MainHandler),
    ('/smartDog', SmartDogAnim),
    ('/spacePants', MainHandler),
    ('/soapOperaDash', MainHandler),
    ('/pirateSolitaire', MainHandler),
    ('/busyBeasHalftimeHustle', MainHandler),
    ('/gardenDash', MainHandler),
    ('/aveyondTheDarkthropProphecy', MainHandler),
    ('/cursedHouse', MainHandler),
    ('/fictionFixersTheCurseOfOz', MainHandler),
    ('/lostInTheCityPostScriptum', MainHandler),
    ('/EM_CharSelect', EM_CharSelectAnim),
    ('/EM_GameOnDevice', EM_GameOnDeviceAnim),
    ('/Knittens', KnittensAnim),
    ('/TSD_Cinemagraph', TSD_CinemagraphAnim),
    ('/TSD_Characters', TSD_CharactersAnim),
    ('/LOTW_Preview', LOTW_PreviewAnim),
    ('/CC_Playable', CC_PlayableAnim),
#Games
    ('/match3Dog', Match3DogGame),
    ('/flyingFish', MainHandler),
    ('/textMeOk', MainHandler),
    ('/mysteryCatFiles', MainHandler),
    ('/babyDaddy', BabyDaddyGame),
#WebApps
    ('/randomRedditbot', RandomRedditbotApp),
#Bonus Pages    
    ('/bio', MainHandler),
    
 #ImageTest
    ('/imageTest', imageTest),
], debug=True)
