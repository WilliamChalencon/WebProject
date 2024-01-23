const express = require("express");// import express.js (framework)
const app = express(); // create an instance of express
const port = 8888; // set up the port number 
const mysql = require("mysql"); //import mysql library
const connexion = mysql.createConnection({ //create a connexion with the database mysql with password and username+ database name
    host: "localhost",
    user: "root",password: "",
    database: "airbeanandbeer"
});

app.use(express.static('rss'));//will connect the server (express) to the rss directory used for the images for example
app.use(express.json());//will enable json request and allow to read these request used for post request
app.use(express.urlencoded({ extended: true }));//will enable json request through URL (eg:/airbeanandbeer)

app.listen(port, () => { //starting the server on port number
    console.log('Server is ready')
});

connexion.connect(error=>{ // connect to sql database using the password and username
    if (error) throw error;
    console.log("Connexion à la database !");
});

app.get("/", (req, res) => {//pulling parameters from the html search form
    const commune = req.query.commune;
    const chambre = req.query.chambre;
    const couchage = req.query.couchage;
    const distance = req.query.distance;
    const prixMin = req.query.prixMin;
    const prixMax = req.query.prixMax;
    const dateDebut = req.query.dateDebut;
    const dateFin = req.query.dateFin;
    res.sendFile("AirBeanAndBeer.html", { root: __dirname });//send the html file as a response
});

app.get("/airbeanandbeer", (req, res) => { //recover the parameter from the search form
    let paramQueryBiens=new Map; // create a kind of dictionnary with Map, one for normal parameters
    let paramQueryLocations=new Map;// one for date
    paramQueryBiens.set('biens.commune',`='${req.query.commune}'`); // store the sql row as key and the search parameters as value 
    paramQueryBiens.set('biens.nbCouchages',req.query.couchage);
    paramQueryBiens.set('biens.nbchambres',req.query.chambre);
    paramQueryBiens.set('biens.distance',`<=${req.query.distance}`);
    paramQueryBiens.set('biens.prix min',`>=${req.query.prixMin}`);
    paramQueryBiens.set('biens.prix max',`<=${req.query.prixMax}`);
    paramQueryLocations.set('locations.dateFin',`${req.query.dateDebut}`);
    paramQueryLocations.set('locations.dateDebut',`${req.query.dateFin}`);

    for (let [clé, valeur] of paramQueryBiens){ //deleting non used parameter
        if(valeur==`=''`||valeur==''||valeur=='<='||valeur=='>='){
            paramQueryBiens.delete(clé);
        }
    }

    for (let [clé, valeur] of paramQueryLocations){ //deleting non used parameter
        if(valeur==''){
            paramQueryLocations.delete(clé);
        }
    }

    if (paramQueryBiens.size===0 && paramQueryLocations.size===0) {
        sql = `SELECT DISTINCT * from biens;`;
    }
    else {
        sql = `SELECT
        biens.idBien, biens.commune, 
        biens.nbCouchages, 
        biens.nbchambres, 
        biens.prix, 
        biens.rue, 
        biens.mail, 
        biens.cp, 
        biens.nbcouchages, 
        biens.distance, 
        biens.nbChambres, 
        biens.distance,
        biens.avis
        FROM biens 
        LEFT JOIN locations 
        ON biens.idBien = locations.idBien WHERE`;
        if (paramQueryBiens.size!==0){ //constructing sql request with 'key = value'
            for (let [clé, valeur] of paramQueryBiens) {
                sql = sql+` ${clé.split(" ")[0]}${valeur} AND`;
            }
        }

        sql = sql+` NOT EXISTS (
            SELECT 1
            FROM locations WHERE biens.idBien = locations.idBien
            AND (
                (locations.dateFin >= '${req.query.dateDebut}' AND locations.dateDebut <= '${req.query.dateFin}') OR
                (locations.dateDebut <= '${req.query.dateDebut}' AND locations.dateFin >= '${req.query.dateFin}') OR
                locations.idBien IS NULL
            )
        ) 
        GROUP BY biens.idBien;`;
        
    }  
    connexion.query(sql, (err, resultat)=>{ //send the sql request to the server and return the result in json
        console.log(sql);
        console.log(resultat);
        res.json(resultat);
    });
});

app.post('/avis', (req,res) => { //recover all the reviews 
    const idBien = req.body.idBien;//recover the bien id

    const sql = `SELECT DISTINCT * FROM avis WHERE bien='${idBien}';` //construct sql request to retrieve review

    connexion.query(sql, (err, resultat)=>{// access to database
        console.log(sql);
        console.log(resultat);
        res.json(resultat);
        if (err) {
            console.error("Error inserting location:", err);
            res.status(500).send("Error inserting location");
        }
    });    
});

app.post('/reservation', (req, res) => {// book a rent 
    // Extract data from the request body
    const idBien = req.body.idBien;
    const dateDebut = req.body.dateDebut;
    const dateFin = req.body.dateFin;
    const mail = req.body.mail;
    // Perform the database insertion
    const sql = `INSERT INTO locations (idBien, dateDebut, dateFin, mailLoueur) VALUES ('${idBien}','${dateDebut}','${dateFin}','${mail}');`;
    connexion.query(sql, (err, resultat) => {
        console.log(sql);
        if (err) {
            console.error("Error inserting location:", err);
            res.status(500).send("Error inserting location");
        } else {
            res.status(200).send("Location inserted successfully");
        }
    });
});

app.post('/newAvis', (req, res) => {//send a review to the databas => to register and update the rating of the rent
    console.log("avis recu!")
    const idBien = req.body.idBien;
    const rating = req.body.rating;
    const commentaire = req.body.commentaire;
    const mail = req.body.mail;
    // insert the reviews in the database
    const sql = 'INSERT INTO avis (bien, note, commentaire, utilisateur) VALUES (?, ?, ?, ?)';
    const values = [idBien, rating, commentaire, mail];
    //update the avg rating of the rent
    const sqlUpdate= `UPDATE biens
SET biens.avis = (
    SELECT AVG(note)
    FROM avis
    WHERE avis.bien = biens.idBien
)
WHERE biens.idBien = '${idBien}';`;
    //access the database
    connexion.query(sql,values, (err, resultat) => {//first insert the review
        console.log(sql);
        if (err) throw err;
        connexion.query(sqlUpdate, (err, resultat) => { // then update the avg rating
            console.log(sqlUpdate);
            if (err) throw err;
            res.status(200).send("Rating sent and updated");
        });
    });
})

