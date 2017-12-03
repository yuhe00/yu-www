'use strict';

require('./styles/reset.css');
require('./styles/index.css');

const Elm = require('./Main');

const main = Elm.Main.embed(document.getElementById('root'));
