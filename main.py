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
import StringIO
from google.appengine.api import images
from PIL import Image, ImageDraw, ImageFont

index_html="""
<!DOCTYPE html><html class=''>
<head>
<title>Ryan Rockers</title>
<link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="http://ryanrockers.appspot.com/smartDog" target="_blank">Ryan Rockers</a>
    </div>
    <ul class="nav navbar-nav">
      <li><a href="#top">Home</a></li>
      <li><a href="#portfolio">Portfolio</a></li>
      <li><a href="#contact">Contact</a></li>
    </ul>
  </div>
</nav>
  
<div id="top">
  <div>
    <img class="img-responsive center-block" src="images/georgeIcon.svg" id="logo">
    <!--div id="button-row" class="btn-group btn-group-justified" role="group">
        <div class="btn btn-lg" role="button">
          <a href="#"><img src="images/georgeIcon.svg" class="img-responsive"></a>
        </div>
    </div-->
  </div>
</div>
    
<div id="portfolio">
  <h1 id="portfolioHeader" class="text-center">Portfolio</h1>
  <br><br>
  <div class="row center-block">
    <div class="col-md-4">
      <div class="thumbnail">
        <a href="/match3Dog" target="_blank"><img src="/images/match3dog_screenshot.jpg" alt="Match 3 Dog"></a>
          <div class="caption">
            <h3>Match 3 Dog</h3>
            <p>I asked my dog about this game recently. He said he liked it, but it gets "ruff". He's a good boy. It's a fun Match-3 game in Flash. Match 4 or more and the dog reacts. Fun for the whole gang. No cats.</p>
          </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="thumbnail">
        <a href="/babyDaddy" target="_blank"><img src="/images/babyDaddy_screenshot.jpg" alt="Baby Daddy"></a>
          <div class="caption">
            <h3>Baby Daddy</h3>
            <p>I became a dad not that long ago, and I'm worried about zombies. I feel better knowing I have the high score in Baby Daddy. Shoot down zombie fish with your trusty bottles. Windows download. Action game written in python/pygame. <a href="https://github.com/word-dudely/Baby-Daddy">Github link</a></p>
          </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="thumbnail">
        <a href="/goAround" target="_blank"><img src="/images/goAround_screenshot.png" alt="Go Around"></a>
          <div class="caption">
            <h3>Go Around</h3>
            <p>My take on a classic hero myth. The monkey wants the banana, and will go to great lengths to get it. He must first challenge a monster in his den, tasting the blood of victory, followed by two more tests to his willpower and determination. When he finally reaches his goal, he has been forever changed by the journey. Flash animation.</p>
          </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="thumbnail">
        <a href="/randomRedditbot" target="_blank"><img src="/images/randomRedditbot_screenshot.png" alt="Random Redditbot"></a>
          <div class="caption">
            <h3>Random Redditbot</h3>
            <p>It's like you're in a room full of people talking to themselves. Kind of soothing really. An important web application.</p>
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

randomRedditbot_html="""
<!DOCTYPE html>
<html >
<head>
<meta charset="UTF-8">


<title>Random Redditbot</title>
<link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css'>
<link type="text/css" rel="stylesheet" href="/stylesheets/randomRedditbot.css" />
<link href='https://fonts.googleapis.com/css?family=Anton&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
</head>

<body>

<div id="results">here it comes...</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>

<script>
$(document).ready(function() {
    var displayText = "<p>";
    var randomSortList = ['hot', 'rising', 'controversial', 'top', 'new'];
    var randomSubredditList = ['all', 'breakingmom', 'dadjokes', 'news', 'space', 'economy', 'business', 'onthescene', 'science', 'Advice', 'confessions', 'riddles', 'UFOs', 'myfriendwantstoknow', 'howto', 'dogs', 'conspiracy', 'oldpeoplefacebook', 'tifu', 'artificial', 'Seattle', 'tech', 'technews', 'democrats', 'republicans', 'inthenews', 'finance', 'gossip', 'singularity', 'AskTechnology', 'AMA', 'paranormal', 'mildlyinteresting', 'worldnews', 'nottheonion', 'shittyaskscience', 'explainlikeimfive', 'philosophy', 'askphilosophy', 'LearnUselessTalents', 'TechNewsToday', 'AmericanPolitics', 'Economics', 'mildlyinfuriating', 'creepyPMs', 'Whatisthis', 'Libertarian', 'MURICA', 'FutureWhatIf', 'wikipedia', 'sanders4president', 'the_donald', 'Hillary_Clinton', 'TedCruzForPresident', 'KasichForPresident', 'cringe', 'cringepics', 'niceguys'];
    var usedList = [['[deleted]',0], [undefined,0], ['[removed]',0]];
    var intervalID = window.setInterval(randomReddit, 4000);

    function randomReddit() {
        $.getJSON('https://www.reddit.com/r/' + randomSubredditList[Math.floor(Math.random() * randomSubredditList.length)] + '/' + randomSortList[Math.floor(Math.random() * randomSortList.length)] + '/.json?limit=1&t=hour', function(data) {
        var link='https://www.reddit.com/r/all/comments/' + (data.data.children[0].data.id);
        $.getJSON('https://www.reddit.com/r/all/comments/' + (data.data.children[0].data.id) + '.json?limit=1', function(data) {
            var comment=data[1].data.children[0].data.body;
            for (var i=0;i<usedList.length;i++) {
            if (usedList[i].indexOf(comment) != -1) {
            return;
            }
            }
            usedList.push([comment,link]);
            displayText="<p>";
            for (var i=usedList.length-1;i>2;i--) {
            displayText += '<a href="'+ usedList[i][1] + '" target="_blank">' + usedList[i][0] + "</a><p><hr><p>";
            }
            $("#results").html(displayText);
            //window.scrollTo(0,document.body.scrollHeight)
            });
        });
    };
    randomReddit();
});
</script>

</body>
</html>
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
#        self.response.write(index_html)
        self.redirect("https://drive.google.com/file/d/0B-swctkKyxQMTnF5cXBoUHNVV28/preview")

#Games

class Match3DogGame (webapp2.RequestHandler):
    def get(self):
#        self.response.write(index_html)
        self.redirect("games/match3dog/Match3.swf")
        
class BabyDaddyGame (webapp2.RequestHandler):
    def get(self):
#        self.response.write(index_html)
        self.redirect("https://drive.google.com/uc?export=download&id=0B-swctkKyxQMQXltN2hFb0JXMnc")
        
#WebApps

class RandomRedditbotApp (webapp2.RequestHandler):
    def get(self):
        self.response.write(randomRedditbot_html)
        
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
