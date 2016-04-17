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