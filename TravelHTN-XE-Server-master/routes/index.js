var express = require("express");
var router = express.Router();
var moment = require("moment");
const request = require("request");

/* GET home page. */
router.get("/from/:from/to/:to", function(req, res, next) {
  var fromCurr = req.params.from;
  var toCurr = req.params.to;
  var endDate = moment().format("YYYY-MM-DD");
  var startDate = moment()
    .subtract(1, "months")
    .format("YYYY-MM-DD");
  var apiUrl = "https://xecdapi.xe.com/v1/";
  apiUrl += "stats?from=" + fromCurr;
  apiUrl += "&to=" + toCurr;
  apiUrl += "&start_date=" + startDate;
  apiUrl += "&end_date=" + endDate;

  var username = "joyang466869584";
  var password = "6kgbjvq8sehkqrutlg1hu57drn";

  var options = {
    url: apiUrl,
    auth: {
      user: username,
      password: password,
      sendImmediately: true
    }
  };

  var resultStats;
  request(options, function(errStats, resStats, bodyStats) {
    resultStats = JSON.parse(bodyStats);
    var high = resultStats.stats[0].high;
    var avg = resultStats.stats[0].average;
    var lowerBoundForGoodRate = (avg + high) / 2;

    var apiUrl = "https://xecdapi.xe.com/v1/";
    apiUrl += "convert_from.json/?from=" + fromCurr;
    apiUrl += "&to=" + toCurr;

    var options = {
      url: apiUrl,
      auth: {
        user: username,
        password: password,
        sendImmediately: true
      }
    };

    var resultCurrConv;
    request(options, function(errCurrConv, resCurrConv, bodyCurrConv) {
      resultCurrConv = JSON.parse(bodyCurrConv);
      var currentRate = resultCurrConv.to[0].mid;
      //   // now check if the currentRate lies between the highest possible rate and the lowerBound for a good rate
      console.log("currentRate: " + currentRate);
      console.log("lowerBoundForGoodRate: " + lowerBoundForGoodRate);
      console.log("high: " + high);
      var response = {
        isGoodRate: false,
        currentRate: currentRate,
        averageRate: avg,
        highestRate: high
      };
      if (currentRate <= high && currentRate >= lowerBoundForGoodRate) {
        response.isGoodRate = true;
      }
      res.send(response);
    });
  });
});

module.exports = router;
