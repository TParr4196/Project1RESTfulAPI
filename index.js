//starter code copied from challenge 1.3
const express = require('express');
const app = express();
app.use(express.json()); //https://stackoverflow.com/questions/11625519/how-to-access-the-request-body-when-posting-using-node-js-and-express

const port = 8086;
businesses = [{
    //used copilot to populate example data
    "name": "example business",
    "address": "123 example st",
    "city": "example city",
    "state": "example state",
    "zip": "12345",
    "phone": "1234567890",
    "category": "example category",
    "subcategory": "example subcategory",
    "website": "example.com",
    "email": "example@example.com",
},{
    "name": "example2 business",
    "address": "1232 example st",
    "city": "example2 city",
    "state": "example 2state",
    "zip": "12325",
    "phone": "1224567890",
    "category": "example2 category",
    "subcategory": "example2 subcategory",
    "website": "example2.com",
    "email": "example2@example.com",
},{
    "name": "example3 business",
    "address": "1333 example st",
    "city": "example3 city",
    "state": "example 3state",
    "zip": "13335",
    "phone": "1334567890",
    "category": "example3 category",
    "subcategory": "example3 subcategory",
    "website": "example3.com",
    "email": "example3@example.com",
},
];
reviews = [
    //used copilot to populate example data
    {
        "stars": 5,
        "dollars": 1,
        "written_review": "example review",
        "business_id": 0
    },{
        "stars": 4,
        "dollars": 2,
        "written_review": "example review 2",
        "business_id": 2
    },{
        "stars": 3,
        "dollars": 3,
        "written_review": "example review 3",
        "business_id": 1
    }
];
photos = [{
    "url": "example.com",
    "caption": "example caption",
    "business_id": 0
},{
    "url": "example2.com",
    "caption": "example caption 2",
    "business_id": 2
},{
    "url": "example3.com",
    "caption": "example caption 3",
    "business_id": 1
},{
    "url": "example4.com",
    "caption": "example caption 4",
    "business_id": 0
},];

app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});


app.get("/", (req, res) => {
    res.send("https://medium.com/@muhammadnaqeeb/dockerizing-a-node-js-and-express-js-app-9cb31cf9139e used for help dockerizing the app!");
});

//Businesses:

function validateBusiness(req, res, next) {
    business = req.body;
    if (business == null){
        return res.status(400).send("Business is null");
    }
    let keys = Object.keys(business);
    requiredKeys = ["name", "address", "city", "state", "zip", "phone", "category", "subcategory"];
    optionalKeys = ["website", "email"];
    //https://stackoverflow.com/questions/19957348/remove-all-elements-contained-in-another-array used for .filter syntax
    missingKeys = requiredKeys.filter( ( el ) => !keys.includes( el ) );
    extraKeys = keys.filter( ( el ) => !requiredKeys.includes( el ) );
    extraKeys = extraKeys.filter( ( el ) => !optionalKeys.includes( el ) );
    if (extraKeys.length > 0 || missingKeys.length > 0) {
        return res.status(400).send("required keys: " + requiredKeys + "\noptional keys: " + optionalKeys + "\nmissing keys: " + missingKeys + "\nInvalid keys: " + extraKeys );
    }
    next();
}

function findBusiness(req, res, next) {
    if (req.params.id > businesses.length || req.params.id < 0) {
        return res.status(404).send("Business not found");
    }
    next();
}

app.post("/business/", validateBusiness, (req, res, next) => {
    businesses.push(req.body);
    res.status(201);
    return res.send({"location": "/business/" + (businesses.length - 1)});
});

app.get("/business/", (req, res, next) => {
    return res.send(businesses);
});

app.get("/business/:id", findBusiness, (req, res, next) => {
    if (businesses[req.params.id] == null) {
        return res.status(404).send("Business not found");
    }
    return res.send(businesses[req.params.id]);
});

app.put("/business/:id", validateBusiness, findBusiness, (req, res, next) => {
    businesses[req.params.id] = req.body;
    res.status(201).send("location: /business/" + req.params.id);
});

app.delete("/business/:id", findBusiness, (req, res, next) => {
    businesses[req.params.id] = null;
    res.status(204).send("Deleted");
});


//Reviews:
function validateReview(req, res, next) {
    review = req.body;
    if (review == null){
        return res.status(400).send("Review is null");
    }
    let keys = Object.keys(review);
    requiredKeys = ["stars", "dollars"];
    optionalKeys = ["written_review"];
    //https://stackoverflow.com/questions/29592989/how-do-i-get-node-js-request-type for .method
    if(req.method == "PUT"){
        requiredKeys= ["stars", "dollars", "business_id"];
    }
    missingKeys = requiredKeys.filter( ( el ) => !keys.includes( el ) );
    extraKeys = keys.filter( ( el ) => !requiredKeys.includes( el ) );
    extraKeys = extraKeys.filter( ( el ) => !optionalKeys.includes( el ) );
    if (extraKeys.length > 0 || missingKeys.length > 0) {
        return res.status(400).send("required keys: " + requiredKeys + "\noptional keys: " + optionalKeys + "\nmissing keys: " + missingKeys + "\nInvalid keys: " + extraKeys );
    }
    if (review["stars"] < 0 || review["stars"] > 5 || review["dollars"] < 1 || review["dollars"] > 4) {
        return res.status(400).send("stars must be between 0 and 5 and dollars must be between 1 and 4");
    }
    if(req.method == "PUT"){
        if (review["business_id"] > businesses.length || review["business_id"] < 0 || review["business_id"] == null) {
            return res.status(404).send("Business not found");
        }
    }
    next();
}

function findReview(req, res, next) {
    if (req.params.id > reviews.length || req.params.id < 0) {
        return res.status(404).send("Review not found");
    }
    next();
}

app.get("/review/", (req, res, next) => {
    res.send(reviews);
});

app.post("/review/:id", validateReview, findBusiness, (req, res, next) => {
    review = req.body;
    review["business_id"] = req.params.id;
    for (oldreview in reviews) {
        if (reviews[oldreview]["business_id"] == req.params.id) {
            return res.status(400).send("Review already exists for this business");
        }
    }
    reviews.push(review);
    res.status(201);
    return res.send({"location": "/review/" + (reviews.length - 1)});
});

app.put("/review/:id", validateReview, findReview, (req, res, next) => {
    if (req.body["business_id"] > businesses.length || req.body["business_id"] < 0 || req.body["business_id"] == null) {
        return res.status(404).send("Business not found");
    }
    reviews[req.params.id] = req.body;
    res.status(201).send("location: /review/" + req.params.id);
});

app.get("/review/:id", findReview, (req, res, next) => {
    if (reviews[req.params.id] == null) {
        return res.status(404).send("Business not found");
    }
    res.send(reviews[req.params.id])
});

app.delete("/review/:id", findReview, (req, res, next) => {
    reviews[req.params.id] = null;
    res.status(204).send("Deleted");
});

//Photos:
function validatePhoto(req, res, next){
    photo = req.body;
    if (photo == null){
        return res.status(400).send("Photo is null");
    }
    let keys = Object.keys(photo);
    requiredKeys = ["url"];
    if(req.method == "PUT"){
        requiredKeys = ["url", "business_id"];
    }
    optionalKeys = ["caption"];
    missingKeys = requiredKeys.filter( ( el ) => !keys.includes( el ) );
    extraKeys = keys.filter( ( el ) => !requiredKeys.includes( el ) );
    extraKeys = extraKeys.filter( ( el ) => !optionalKeys.includes( el ) );
    if (extraKeys.length > 0 || missingKeys.length > 0) {
        return res.status(400).send("required keys: " + requiredKeys + "\noptional keys: " + optionalKeys + "\nmissing keys: " + missingKeys + "\nInvalid keys: " + extraKeys );
    }
    if(req.method == "PUT"){
        if (photo["business_id"] > businesses.length || photo["business_id"] < 0 || photo["business_id"] == null) {
            return res.status(404).send("Business not found");
        }
    }
    next();
}

function findPhoto(req, res, next) {
    if (req.params.id > photos.length || req.params.id < 0) {
        res.status(404).send("Photo not found");
    }
    next();
}

app.post("/photo/:id", validatePhoto, findBusiness, (req, res, next) => {
    if (req.params.id > businesses.length || req.params.id < 0) {
        return res.status(404).send("Business not found");
    }
    photo = req.body;
    photo["business_id"] = req.params.id;
    photos.push(photo);
    res.status(201);
    return res.send({"location": "/photo/" + (photos.length - 1)});
});

app.get("/photo/", (req, res, next) => {
    res.send(photos);
});

app.put("/photo/:id", validatePhoto, findPhoto, (req, res, next) => {
    res.send(photos[req.params.id]);
});

app.get("/photo/:id", findPhoto, (req, res, next) => {
    if (photos[req.params.id] == null) {
        return res.status(404).send("Photo not found");
    }
    res.send(photos[req.params.id]);
});

app.delete("/photo/:id", findPhoto, (req, res, next) => {
    photos[req.params.id] = null;
    res.status(204).send("Deleted");
});