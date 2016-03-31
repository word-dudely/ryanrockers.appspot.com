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

index_html="""
<!DOCTYPE html><html class=''>
<head>
<link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
<style class="cp-pen-styles">
#top {
  padding-top: 50px;
  min-height: 100vh;
  background-color: red;
}
#logo {
  padding-top: 15vh;
  padding-bottom: 15vh;
}
#portfolio {
  padding-top: 5vh;
  min-height: 100vh;
  background-color: blue;
  margin-right: auto;
  margin-left: auto;
  padding-bottom: 5vh;
}

#portfolioHeader {
 color: white;
}

#contactHeader {
 color: black;
}

#contact {
  padding-top: 5vh;
  min-height: 100vh;
  background-color: grey;  
}

#button-row {
  min-height: 30vh;
}

</style>
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="http://ryanrockers.appspot.com" target="_self">Ryan Rockers</a>
    </div>
    <ul class="nav navbar-nav">
      <li><a href="#top">Home</a></li>
      <li><a href="#portfolio">Portfolio</a></li>
      <li><a href="#contact">Contact</a></li>
    </ul>
  </div>
</nav>
  
<div id="top">
  <div id="logo">
    <img class="img-responsive col-xs-4 col-xs-offset-4" src="http://ryanrockers.appspot.com/images/manAndPlant.svg">
  </div>
</div>
    
<div id="portfolio">
  <h1 id="portfolioHeader" class="text-center">Portfolio</h1>
  <br><br>
  <div class="row center-block">
    <div class="col-md-4">
      <div class="thumbnail">
        <a href="/match3Dog"><img src="/images/match3dog_screenshot.jpg" alt="Match 3 Dog"></a>
          <div class="caption">
            <h3>Match 3 Dog</h3>
            <p>I asked my dog about this game recently. He said he liked it, but it gets "ruff". He's a good boy. It's a fun Match-3 game in Flash. Match 4 or more and the dog reacts. Fun for the whole gang. No cats.</p>
          </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="thumbnail">
        <a href="/babyDaddy"><img src="/images/babyDaddy_screenshot.jpg" alt="Baby Daddy"></a>
          <div class="caption">
            <h3>Baby Daddy</h3>
            <p>I became a dad not that long ago, and I'm worried about zombies. I feel better knowing I have the high score in Baby Daddy. Shoot down zombie fish with your trusty bottles. Windows download. Written in python/pygame. <a href="https://github.com/word-dudely/Baby-Daddy">Github link</a></p>
          </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="thumbnail">
        <a href="/goAround"><img src="/images/goAround_screenshot.png" alt="Go Around"></a>
          <div class="caption">
            <h3>Go Around</h3>
            <p>My take on a classic hero myth. The monkey wants the banana, and will go to great lengths to get it. He must first challenge a monster in his den, tasting the blood of victory, followed by two more tests to his willpower and determination. When he finally reaches his goal, he has been forever changed by the journey.</p>
          </div>
      </div>
    </div>
  </div>
</div>

<div id="contact">
    <h1 id="contactHeader" class="text-center">Contact</h1>
  <br><br><br><br><br><br>
  <div id="button-row" class="btn-group btn-group-justified" role="group">
    <div class="btn btn-default btn-lg" role="button">
      <a href="mailto:ryanrockers@gmail.com"><img src="http://cdn.onlinewebfonts.com/svg/img_15943.svg" class="img-responsive"><p><br>Email</a>
    </div>
    <div class="btn btn-default btn-lg" role="button">
      <a href="https://github.com/word-dudely/" target="_blank"><img src="http://image005.flaticon.com/25/svg/25/25231.svg" class="img-responsive"><p><br>
GitHub</a>
    </div>
    <div class="btn btn-default btn-lg" role="button">
      <a href="http://www.freecodecamp.com/word-dudely" target="_blank"><img src="https://cdn.rawgit.com/Deftwun/e3756a8b518cbb354425/raw/6584db8babd6cbc4ecb35ed36f0d184a506b979e/free-code-camp-logo.svg" class="img-responsive"><p><br>freeCodeCamp</a>
    </div>
    <div class="btn btn-default btn-lg" role="button">
      <a href="http://codepen.io/word-dudely" target="_blank"><img src="http://codepen.io/logo-pin.svg" class="img-responsive"><p><br>CodePen</a>
    </div>
  </div>
</div>

</body></html>
"""

#Main pages
class MainHandler(webapp2.RequestHandler):
    def get(self):		
        self.response.write(index_html)

#Animations

class GoAroundAnim (webapp2.RequestHandler):
    def get(self):
#        self.response.write(index_html)
        self.redirect("https://drive.google.com/file/d/0B-swctkKyxQMdGRua0pMQlpiNk0/preview")
		
class SmartDogAnim (webapp2.RequestHandler):
    def get(self):
        self.response.write(index_html)

#Games

class Match3DogGame (webapp2.RequestHandler):
    def get(self):
#        self.response.write(index_html)
        self.redirect("games/match3dog/Match3.swf")

class TextMeOkGame (webapp2.RequestHandler):
    def get(self):
#        self.response.write(index_html)
        self.redirect("games/text_me_ok/textMeOk.swf")
        
class BabyDaddyGame (webapp2.RequestHandler):
    def get(self):
#        self.response.write(index_html)
        self.redirect("https://drive.google.com/uc?export=download&id=0B-swctkKyxQMQXltN2hFb0JXMnc")
		

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
#Games
    ('/match3Dog', Match3DogGame),
    ('/flyingFish', MainHandler),
    ('/textMeOk', TextMeOkGame),
	('/mysteryCatFiles', MainHandler),
    ('/babyDaddy', BabyDaddyGame),
#Bonus Pages    
    ('/bio', MainHandler),
], debug=True)
