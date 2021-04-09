const express = require("express");
const router = express.Router();
router.use(express.json());
var mysql = require("mysql");
require("dotenv/config");

router.use(express.json());

var connection = mysql.createConnection({
    host: process.env.HOST_NAME,
    user: process.env.USER_NAME,
    password: process.env.PASSWORD,
    database: process.env.DATABASE_NAME,
  });
  
  connection.connect(function (err) {
    if (err) {
      console.error("error connecting: " + err.stack);
      return;
    }
    console.log("connected as id " + connection.threadId);
  });
let zoomLevel = 2;
let lat;
let long;

//map request
router.get("/", (req, res) => {
    zoomLevel = 4;
    console.log("map request");
    res.render("index.pug", {
        lat: 37.566826,
        long: 127.9786567,
        zoomInTo: zoomLevel,
    });
});
// router.get("/zoomOut1", (req, res) => {
//     zoomLevel += 1;
//     lat = Math.abs(parseFloat(req.query.lat));
//     long = Math.abs(parseFloat(req.query.long));
//     res.render("index.pug", {
//         lat: lat,
//         long: long,
//         zoomInTo: zoomLevel
//     });
// });
// router.get("/zoomIn", (req, res) => {
//     if (zoomLevel >= 1) zoomLevel -= 1;
//     lat = Math.abs(parseFloat(req.query.lat));
//     long = Math.abs(parseFloat(req.query.long));
//     res.render("index.pug", {
//       lat: lat,
//       long: long,
//       zoomInTo: zoomLevel
//     });
//   });
// router.get("/zoomOut", (req, res) => {
//     zoomLevel += 1;
//     lat = Math.abs(parseFloat(req.query.lat));
//     long = Math.abs(parseFloat(req.query.long));
//     res.render("index.pug", {
//       lat: lat,
//       long: long,
//       zoomInTo: zoomLevel
//     });
//   });
router.get("/getPos", (req, res) => {
    zoomLevel = 4;
    console.log(req.query);
    lat = Math.abs(parseFloat(req.query.lat));
    long = Math.abs(parseFloat(req.query.long));

    res.render("index.pug", {
        lat: lat,
        long: long,
        zoomInTo: zoomLevel
    });
});
router.get("/getAddress", (req, res) => {
    zoomLevel = 7;
    let address = req.query.address;
    console.log(address);
    res.render("search.pug", {
        lat: 37.566826,
        long: 127.9786567,
        zoomInTo: zoomLevel,
        address: address,
        zoomInTo: zoomLevel,
    });
});
router.get("/searchCategory", (req, res) => {
    zoomLevel = 4;
    lat = Math.abs(parseFloat(req.query.lat));
    long = Math.abs(parseFloat(req.query.long));

    let {
        menu,
        bed,
        tableware,
        meetingroom,
        diapers,
        playroom,
        carriages,
        nursingroom,
        chair,
        Area,
        Locality
    } = req.query;
    let address = Area + " " + Locality;

    let request1 = [
        menu,
        bed,
        tableware,
        meetingroom,
        diapers,
        playroom,
        carriages,
        nursingroom,
        chair,
    ];
    const body1 = [
        "menu",
        "bed",
        "tableware",
        "meetingroom",
        "diapers",
        "playroom",
        "carriage",
        "nursingroom",
        "chair",
    ];
    let sql1 = "";
    let query1 = "";
    let count = 0;
    for (let i = 0; i < request1.length; i++) {
        if (request1[i] == "false") {
            ++count;
            query1 = " " + body1[i] + " ='○' ";
            if (count > 1) {
                sql1 += " and " + query1;
            } else {
                sql1 += query1;
            }
        }
    }
    //  sql = sql1 == "" ? "" : "select * from restaurant where address like '%"+address+"%' and" + sql1+ ";";
    sql = sql1 == "" ? "" : "select * from restaurant where " + sql1;
    console.log(sql1);
    console.log(sql);
    let resultData = [];
    if (sql == "") {
        res.render("index.pug", {
            data: resultData,
            lat: lat,
            long: long,
            zoomInTo: zoomLevel,
        });
    } else {
        try {
            connection.query(sql, (err, results) => {
                if (err) {
                    console.log(err);
                    res.end();
                } else {
                    console.log(results.length);
                    for (let i = 0; i < results.length; i++) {
                        // console.log(results[i]);
                        resultData.push({
                            store_name: results[i]["store_name"],
                            address: results[i]["address"],
                            phone: results[i]["phone"],
                            menu: results[i]["menu"],
                            bed: results[i]["bed"],
                            tableware: results[i]["tableware"],
                            meetingroom: results[i]["meetingroom"],
                            diapers: results[i]["diapers"],
                            playroom: results[i]["playroom"],
                            carriage: results[i]["carriage"],
                            nursingroom: results[i]["nursingroom"],
                            chair: results[i]["chair"],
                            lat: results[i]["lat"],
                            lon: results[i]["lon"],
                        });
                        // resultData.push(results[i]["address"]);
                    }
                    // console.log(resultData);
                    res.render("serchmarker.pug", {
                        data: resultData,
                        lat: lat,
                        long: long,
                        zoomInTo: zoomLevel,
                    });
                    // console.log(resultData);
                }
            });
        } catch (error) {
            console.log(error);
            res.end();
        }
    }
});

router.get("/storename", (req, res) => {
    let {
        storename,
        address
    } = req.query;
    console.log(storename);
    console.log(address);
    res.render("storenamemarker.pug", {
        storename: storename,
        address: address,
        zoomInTo: 1,
    });
});
router.get("/homesearch", (req, res) => {
    console.log("homesesarch");
    let {
        lat,
        long,
        address
    } = req.query;
    let sql = "SELECT * FROM restaurant";

    let resultData = [];
    try {
        connection.query(sql, (err, results) => {
            if (err) {
                req.flash("error", err);
            } else {
                console.log(results.length);
                for (let i = 0; i < results.length; i++) {
                    // console.log(results[i]);
                    resultData.push({
                        store_name: results[i]["store_name"],
                        address: results[i]["address"],
                        phone: results[i]["phone"],
                        menu: results[i]["menu"],
                        bed: results[i]["bed"],
                        tableware: results[i]["tableware"],
                        meetingroom: results[i]["meetingroom"],
                        diapers: results[i]["diapers"],
                        playroom: results[i]["playroom"],
                        carriage: results[i]["carriage"],
                        nursingroom: results[i]["nursingroom"],
                        chair: results[i]["chair"],
                        lat: results[i]["lat"],
                        lon: results[i]["lon"],
                    });
                    // resultData.push(results[i]["address"]);
                }

                res.render("homesearch.pug", {
                    lat1: lat,
                    lon1: long,
                    data: resultData,
                    address: address,
                    zoomInTo: zoomLevel,
                });
            }

        });
    } catch (error) {
        res.status(404).json({
            message: error
        });
    }

});
router.get("/searchlist", (req, res) => {
    let lat = req.query.lat;
    let long = req.query.long;
    let searchkey = req.query.searchkey;
    console.log("lat" + lat + "," + "long" + long + "," + searchkey);
    res.render("searchlist.pug", {
        lat: lat,
        long: long,
        searchkey: searchkey,
    });
});
router.get("/listsearchmarker/:liststringdata", (req, res) => {
    let liststringdata = req.params.liststringdata;
    let {
        lat,
        long,
        Area,
        Locality
    } = req.query;
    let address = Area + " " + Locality;

    let sql = "SELECT * FROM " + liststringdata + " ;";
    console.log(sql);
    let resultData = [];
 
    console.log(sql);
    try {
        connection.query(sql, (err, results) => {
            if (err) {
                res.json({"error": err});
            } else {
                for (let i = 0; i < results.length; i++) {
                    resultData.push({
                        store_name: results[i]["store_name"],
                        address: results[i]["address"],
                        phone: results[i]["phone"],
                        menu: results[i]["menu"],
                        bed: results[i]["bed"],
                        tableware: results[i]["tableware"],
                        meetingroom: results[i]["meetingroom"],
                        diapers: results[i]["diapers"],
                        playroom: results[i]["playroom"],
                        carriage: results[i]["carriage"],
                        nursingroom: results[i]["nursingroom"],
                        chair: results[i]["chair"],
                        Examination_item: results[i]["Examination_item"],
                        fare: results[i]["fare"],
                        lat: results[i]["lat"],
                        lon: results[i]["lon"],
                    });
                }

                res.render("listsearchmarker.pug", {
                    lat1: lat,
                    lon1: long,
                    data: resultData,
                    liststringdata: liststringdata,
                });
            }
        });
    } catch (error) {

    }

});

module.exports = router;