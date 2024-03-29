var crypto = require('crypto'),
    Document,
    User,
    LoginToken;

function defineModels(mongoose, fn) {
  var Schema = mongoose.Schema,
  ObjectId = Schema.ObjectId;

  function changeNumVotes(v) {
    this.votes = (this.upVotes || 0) - (this.downVotes || 0);
    return v;
  }

  // Model: Poster
  Artwork = new Schema({
    'name': {type: String, index: true, 'default': 'Unknown'},
    'bucket': {type: String},
    'key': {type: String, index: { unique: true }},
    'etag': {type: String}, // From S3
    's3Loc': {type: String}, 
    'uploadTime': {type: Number},
    'uploadDateStr': {type: String},
    'versionNum': {type: Number, 'default': 1},
    'isInReview': {type: Boolean, 'default': true},
    'upVotes': {type: Number, 'default': 0, set: changeNumVotes},
    'downVotes': {type: Number, 'default': 0, set: changeNumVotes},
    'votes': {type: Number},
    'userId': {type: ObjectId, index: true},
    '_userId' : { type: Schema.ObjectId, ref: 'User' }
  });

  // InfoLog Explained:
  // InfoLog stores a history of all changes
  // Its an array where each element is an obj with the state of the transcription during the last change
  // infoLogStr is whats stored in the db, and its stringified in pre
  // infoLogObj is what should be in the obj when saving
  // infoLog is a convenience method that calls JSON.parse on infoLogStr

  Artwork.virtual('id')
    .get(function() {
      return this._id.toHexString();
  });
  Artwork.virtual('infoLog')
    .get(function() {
      return JSON.parse(this.infoLogStr);
  });

  function makeReadableTime(mill) {
    var d = new Date(mill);
    var month = d.getMonth() + 1;
    var day = d.getDate();
    var year = d.getFullYear();
    return month + '/' + day + '/' + year;
  }
  Artwork.pre('save', function(next) {
    this.votes = this.upVotes - this.downVotes;

    // Convert to readable time
    if (!this.uploadTime) {
      this.uploadTime = Date.now();
    }
    this.uploadDateStr = makeReadableTime(this.uploadTime);
    // Collapse if only whitespace
    if (!(/\S/.test(this.description))) {
      // string is all whitespace
      this.description = '';
    }

    //Stringify info log
    this.infoLogStr = JSON.stringify(this.infoLogObj);
    next();
  });
  /*
  Artwork.virtual('votes')
    .get(function() {
      this.votes = this.upVotes - this.downVotes;
      return this.upVotes - this.downVotes;
  });
  */

  /**
    * Model: User
    */
  function validatePresenceOf(value) {
    return value && value.length;
  }

  User = new Schema({
    'username': { type: String, validate: [validatePresenceOf, 'a username is required'], index: { unique: true } },
    'email': { type: String, lowercase: true,  validate: [validatePresenceOf, 'an email is required'], index: { unique: true } },
    //'profPicLoc': {type: String}, //index: { unique: true}},

    // Array of poster ids
    'upVotes': {type: [String], 'default': []},
    'downVotes': {type: [String], 'default': []},
    'isArtist': {type: Boolean, 'default': false},

    'karmaPoints': {type: Number, 'default': 10},
    'personalWebsite': {type: String},
    'hashed_password': String,
    'registerTime': {type: Number},
    'registerDateStr': {type: String},
    'salt': String
  });

  User.virtual('id')
    .get(function() {
      return this._id.toHexString();
    });

  User.virtual('password')
    .set(function(password) {
      this._password = password;
      this.salt = this.makeSalt();
      this.hashed_password = this.encryptPassword(password);
    })
    .get(function() { return this._password; });

  // Returns if the user has voted for a particular
  // transcription or not. 0 for no, 1 for downVote,
  // 2 for upVote
  User.statics.hasVoted = function(userId, trId, cb) {
    this.findById(userId, function(err, user) {
      if (user.upVotes.indexOf(trId) > -1) {
        cb(err, 2);
      } else if (user.downVotes.indexOf(trId) > -1) {
        cb(err, 1);
      } else {
        cb(err, 0);
      }
    });
  };

  User.method('authenticate', function(plainText) {
    return this.encryptPassword(plainText) === this.hashed_password;
  });

  User.method('makeSalt', function() {
    return Math.round((new Date().valueOf() * Math.random())) + '';
  });

  User.method('encryptPassword', function(password) {
    return crypto.createHmac('sha1', this.salt).update(password).digest('hex');
  });

  // Never have < 0 karmaPoints
  User.pre('save', function(next) {
    // Convert to readable time
    if (!this.registerTime) {
      this.registerTime = Date.now();
    }
    this.registerDateStr = makeReadableTime(this.registerTime);

    if (this.karmaPoints < 0) {
      this.karmaPoints = 0;
    }
    next();
  });

  /*
  User.pre('save', function(next) {
    if (!validatePresenceOf(this.password)) {
      next(new Error('Invalid password'));
    } else {
      next();
    }
  });
  */

  /**
    * Model: LoginToken
    *
    * Used for session persistence.
    */
  LoginToken = new Schema({
    username: { type: String, index: true },
    series: { type: String, index: true },
    token: { type: String, index: true }
  });

  LoginToken.method('randomToken', function() {
    return Math.round((new Date().valueOf() * Math.random())) + '';
  });

  LoginToken.pre('save', function(next) {
    // Automatically create the tokens
    this.token = this.randomToken();

    if (this.isNew)
      this.series = this.randomToken();

    next();
  });

  LoginToken.virtual('id')
    .get(function() {
      return this._id.toHexString();
    });

  LoginToken.virtual('cookieValue')
    .get(function() {
      return JSON.stringify({ username: this.username, token: this.token, series: this.series });
    });

  /**
    * Model: Bounty
    */

  Bounty = new Schema({
    'hasUploaded': {type: Boolean, 'default': false},
    'fulfilled': {type: Boolean, 'default':false},
    'filledById': {type: ObjectId},
    'transcriptionId': { type: String},
    'points': {type: Number},
    'title': {type: String, index: true},
    'album': {type: String, index: true},
    'artist': {type: String, index: true},
    'instrument': {type: String, index: true},
    'description': {type: String},
    'userId': {type: ObjectId, index: true}
  });

  Bounty.virtual('id')
    .get(function() {
      return this._id.toHexString();
  });

  // Create models
  mongoose.model('Artwork', Artwork);
  mongoose.model('User', User);
  mongoose.model('LoginToken', LoginToken);
  mongoose.model('Bounty', Bounty);

  fn();
}


exports.defineModels = defineModels;
