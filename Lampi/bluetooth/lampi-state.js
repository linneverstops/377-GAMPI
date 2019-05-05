var events = require('events');
var util = require('util');
var mqtt = require('mqtt');
var fs = require("fs");

function LampiState() {
    events.EventEmitter.call(this);
    this.board_colors = fs.readFileSync("../board_colors.txt").toString("utf-8");
    this.board_colors = this.board_colors.split("\n")
    this.board_colors.pop()
    console.log(this.board_colors)
    this.is_on = true;
    this.clientId = 'lamp_bt_peripheral';
    this.has_received_first_update = false;

    var that = this;
}
util.inherits(LampiState, events.EventEmitter);
module.exports = LampiState;
