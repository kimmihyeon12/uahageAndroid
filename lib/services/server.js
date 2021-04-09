const express = require("express");
const app = express();
var mysql = require("mysql");
const profile = require("./routes/api/profile");
const map = require("./routes/api/map");
require('dotenv').config();

app.use("/api/profile", profile);
app.use(express.json());
app.use("/map", map);

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



app.set("view engine", "pug");
let zoomLevel = 2;
let lat;
let long;

app.post("/updateNickname/:nickname", async (req, res) => {
  let nickname = req.params.nickname;
  let {
    gender,
    birthday,
    age,
    userId
  } = req.body;
  let sql =
    "update myPage AS a, (SELECT email FROM myPage where email = ? ) as b SET a.nickname = ?, a.gender = ?, a.birthday = ?, a.age = ? WHERE a.email = b.email;";
  console.log(sql);
  try {
    connection.query(
      sql,
      [userId, nickname, gender, birthday, age],
      (err, results) => {
        if (err) {
          // console.log(err);
          res.status(404).json({
            err: err
          });
        } else {
          console.log(results);
          if (results.affectedRows != 0) {
            res.status(200).json({
              message: "성공적으로 업데이트됨"
            }); // Updated successfully.
          } else {
            res.status(200).json({
              message: "업데이트할 수 없습니다"
            }); //Could not update
          }
          res.end();
        }
      }
    );
  } catch (error) {
    console.log(error);
    res.status(404).json({
      message: error
    });
  }
});



//Saving a new using
app.post("/saveUser", async (req, res) => {
  let {
    nickname,
    gender,
    birthday,
    age,
    email,
    URL
  } = req.body;
  console.log(req.body);
  let sql = "insert into myPage values (?)";
  try {
    connection.query(
      sql,
      [
        [email, nickname, gender, birthday, age, URL]
      ],
      (err, results) => {
        if (err) {
          console.log(err.sqlMessage);
          res.status(404).json({
            message: err.sqlMessage
          });
        } else {
          console.log(results);
          if (results.affectedRows == 1) {
            res
              .status(200)
              .json({
                message: "데이터가 성공적으로 저장되었습니다"
              }); // saved success
          } else {
            res.status(500).json({
              message: "오류가 발생했습니다"
            }); //Error occured
          }
        }
      }
    );
  } catch (error) {
    res.status(404).json({
      message: "저장할 수 없습니다"
    }); // Could not save
  }
});

//to load nickname on myPage
app.get("/getMyNickname", async (req, res) => {
  let userId = req.query.userId;
  console.log(userId);
  let sql = "select nickname from myPage where email = ?";
  try {
    connection.query(sql, [userId], (err, results) => {
      if (err) {
        res.status(404).json({
          message: err.sqlMessage
        });
      } else {
        console.log("get mynickname ");
        console.log(results);
        res.status(200).json(results[0]);
      }
    });
  } catch (error) {
    res.status(404).json({
      message: error
    });
  }
});

app.get("/getList/:liststringdata", (req, res) => {
  let liststringdata = req.params.liststringdata;
  // console.log(liststringdata);
  // let maxCount = parseInt(req.query.maxCount);
  // console.log("max count: ");
  // console.log(`maxCount: ${maxCount}`);
  let sql = "SELECT * FROM " + liststringdata;
  // let sql = "SELECT * FROM " + liststringdata + " limit ?, 10"; // + " limit 10 offset " + maxCount + ";";
  console.log(sql);
  connection.query(sql,  (err, rows) => {//[maxCount],
      if (err) {
          console.log(err);
          res.json({
              error: err
          });
          // render to views/books/index.ejs
      } else {
          // render to views/books/index.ejs
          console.log(rows.length);
          if(rows.length == 0){
            res.json([false]);
          }else{
          res.status(200).json(rows);
          }
      }
  });
});
//
app.get("/getNicknames/:nickname", async (req, res) => {
  let nickcname = req.params.nickname;
  console.log(nickcname);
  let sql = "select * from myPage where nickname = ?";
  try {
    connection.query(sql, [nickcname], (err, results) => {
      if (err) {
        res.status(404).json({ err: err });
      } else {
        console.log(results);
        if (results.length == 0)
          res.status(200).json({ message: "사용 가능한 닉네임입니다." });
        else res.status(404).json({ message: "이미 사용중인 닉네임입니다." });
      }
    });
  } catch (error) {
    res.status(404).json({ err: error });
  }
});

app.get("/getMyInfo", async (req, res) => {
  let userId = req.query.userId;
  console.log(userId);
  let sql = "select * from myPage where email = ?";
  try {
    connection.query(sql, [userId], (err, results) => {
      if (err) {
        res.status(404).json({
          message: err.sqlMessage
        });
      } else {
        console.log(results);
        res.status(200).json(results[0]);
      }
    });
  } catch (error) {
    res.status(404).json({
      message: error
    });
  }
});

app.get("/getEmail", async (req, res) => {
  let {
    email
  } = req.query;
  console.log(email);
  let sql = "select * from myPage where email = ?";
  try {
    connection.query(sql, [email], (err, results) => {
      if (err) {
        res.status(404).json({
          message: err.sqlMessage
        });
      } else {
        console.log(results.length);
        res.status(200).json({
          length: results.length
        });
      }
    });
  } catch (error) {
    res.status(404).json({
      message: error
    });
  }
});

app.put("/updateImage/:id", (req, res) => {
  let id = req.params.id;
  let URL = req.body.URL;
  console.log(URL);
  let sql = `UPDATE myPage SET URL = ? WHERE email = ?`;
  try {
    connection.query(sql, [URL, id], (err, results, fields) => {
      console.log(results);
      if (err) {
        res.status(404).json({
          message: err.sqlMessage
        });
      } else {
        res.status(200).json({
          message: "성공적으로 업데이트되었습니다"
        }); //Successfully updated!
      }
    });
  } catch (error) {
    res.status(404).json({
      message: error.sqlMessage
    });
  }
});

//Get user avatar
app.get("/getAvatar", async (req, res) => {
  let {
    email
  } = req.query;
  console.log(email);
  let sql = "select URL from myPage where email = ?";
  try {
    connection.query(sql, [email], (err, results) => {
      if (err) {
        res.status(404).json({
          message: err.sqlMessage
        });
      } else {
        console.log("getAvatar ");
        console.log(results);
        if (results.length != 0)
          res.status(200).json({
            image: results[0].URL
          });
        else res.status(404).json({
          message: "Please log in first"
        });
      }
    });
  } catch (error) {
    res.status(404).json({
      message: error
    });
  }
});

app.post("/star", async (req, res) => {
  let id = null;
  let {
    user_id,
    store_name,
    address,
    phone,
    menu,
    bed,
    tableware,
    meetingroom,
    diapers,
    playroom,
    carriage,
    nursingroom,
    chair,
    fare,
    Examination_item,
    star_color,
    type
  } = req.body;

  if (star_color) {
    let sql = "insert into star_list values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    try {
      connection.query(
        sql,
        [
          id,
          user_id,
          store_name,
          address,
          phone,
          menu,
          bed,
          tableware,
          meetingroom,
          diapers,
          playroom,
          carriage,
          nursingroom,
          chair,
          fare,
          Examination_item,
          type,
        ],
        (err, results) => {
          if (err) {
            console.log(err.sqlMessage);
            res.end();
          } else {
            console.log(results);
            res.end();
          }
        }
      );
    } catch (error) {
      res.status(404).json({
        message: error });
    }
    
  } else {
    let sql = "delete from star_list where user_id =? and address=? and id >0 ";
    try {
      connection.query(sql, [user_id, address], (err, results) => {
      res.send(results)
    });
    } catch (error) {
      res.status(404).json({
        message: error });
    }
    
  }
});


app.get("/starlist", (req, res) => {
  let {user_id} = req.query;

  console.log(user_id);

  let sql = "select * from star_list where user_id= ? ;";
  try {
    connection.query(sql, [user_id], (err, rows) => {
    if (err) {
      console.log(err);
      res.json({
        error: err
      });
    } else {
      console.log(rows);
      res.status(200).json(rows);
    }
  });
  } catch (error) {
    res.status(404).json({
      message: error });
  }
  
});
//rest api get-star-color
app.post("/getStarColor", (req, res) => {
  const {
    userId,
    storeName
  } = req.body;
  console.log(userId);
  console.log(storeName);
  console.log(req.body);
  let sql = "select * from star_list where user_id = ? and store_name =? ;";
  try {
    connection.query(sql, [userId, storeName], (err, results) => {
      if (err) {
        console.log(err);
        res.json({
          error: err
        });
      } else {
        console.log(results);
        console.log(results.length);
        if (results.length > 0) res.sendStatus(200);
        else res.sendStatus(500);
      }
    });
  } catch (error) {
    console.log(error);
    res.status(404).json(error);
  }
  // res.end();
});

app.get("/starcolor", (req, res) => {
  let user_id = req.query.user_id;
  let tablename = req.query.tablename;
  console.log("starcolor");
  console.log(user_id);
  let sql =
    " select  st.store_name from " +
    tablename +
    " re left outer join (select * from star_list where user_id=? ) as st  on re.store_name = st.store_name; ";
  try {
    connection.query(sql, [user_id], (err, rows) => {
      if (err) {
        console.log(err);
        res.json({
          error: err
        });
      } else {
        // console.log(rows);

        res.status(200).json(rows);
      }
    });
  } catch (error) {
    console.log(error);
    res.status(404).json(error);
  }
});

app.get("/substarcolor", (req, res) => {
  let user_id = req.query.user_id;
  let storename = req.query.storename;
  console.log(req.query);
  let sql =
    " select store_name from star_list where store_name = ? and user_id = ? ;";
    try {
      connection.query(sql, [storename, user_id], (err, rows) => {
    console.log(sql);

    if (err) {
      console.log(err);
      res.json({
        error: err
      });
    } else {
      console.log("rows");
      console.log(rows);

      res.status(200).json(rows);
    }
  });
    } catch (error) {
      res.status(404).json({
        message: error });
    }
  
});

app.delete("/deleteProfile/:userId", (req, res) => {
  const userId = req.params.userId;
  console.log("delete profile");
  console.log(userId);
  let sql = "delete from myPage where email = ?;";
  try {
    connection.query(sql, [userId], (err, result) => {
      if (err) {
        res.status(404).json({
          message: err.sqlMessage
        });
      } else {
        console.log(result);
        res.status(200).json({
          message: "성공적으로 삭제됨"
        }); //Succesfully deleted
      }
    });
  } catch (error) {
    res.status(404).json({
      message: error
    });
  }
});

// delete star
app.delete("/deleteStar/:userId", (req, res) => {
  const userId = req.params.userId;
  console.log("delete star");
  console.log(userId);
  let sql = "delete from star_list where user_id = ?;";
  try {
    connection.query(sql, [userId], (err, result) => {
      if (err) {
        res.status(404).json({
          message: err.sqlMessage
        });
      } else {
        console.log(result);
        res.status(200).json({
          message: "성공적으로 삭제됨"
        }); //Succesfully deleted
      }
    });
  } catch (error) {
    res.status(404).json({
      message: error
    });
  }
});


app.listen(process.env.PORT_ADDRESS, () => console.log("server is listening on port 3000"));

/**
 * index
 * show
 * create
 * update
 * delete
 */