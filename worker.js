var request = require('request');

var url = 'https://community-hacker-news-v1.p.mashape.com';
var headers = {
    'Accept': 'application/json',
    'X-Mashape-Key': 'XXXX-XXXX-XXXX-XXXX'
};

request({url: url + '/topstories.json', headers: headers}, function(error, response, body) {
    if (!error && response.statusCode == 200) {
        var postIds = JSON.parse(body);

        for (var i = 0; i < 5; i++) {
            var postId = postIds[Math.floor(Math.random() * postIds.length)];
            request({url: url + '/item/' + postId + '.json', headers: headers}, function(error, response, body) {

                request.post('http://localhost:4985/todos/', {body: body}, function(error, response, body) {
                    console.log(body);
                });

            });
        }

    }
});