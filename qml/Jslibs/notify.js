
function test(tooken, callback){
    var req = new XMLHttpRequest();
req.open("post", "https://push.ubports.com/notify", true);
req.setRequestHeader("Content-type", "application/json");
req.onreadystatechange = function() {
        if ( req.readyState === XMLHttpRequest.DONE ) {
                        console.log("✍ Answer:", req.responseText);
        }
}
var approxExpire = new Date ();
approxExpire.setUTCMinutes(approxExpire.getUTCMinutes()+10);
req.send(JSON.stringify({
        "appid" : "s60w79.warnapp-deutschland_s60w79.warnapp-deutschland",
        "expire_on": approxExpire.toISOString(),
        "token": tooken,
        "data": {
                "notification": {
                        "card": {
                                "icon": "notification",
                                "summary": "Achtung!",
                                "body": "Testwarnung blablablablablaballukdwbuibduibcuigbuisgbcuiu",
                                "popup": true,
                                "persist": true
                        },
                "vibrate": true,
                "sound": true
                }
        }
}));
callback();
}
