var util = require('util');
var bleno = require('bleno');

var CHARACTERISTIC_NAME = 'board_colors';

function LampiBoardColorsCharacteristic(lampiState) {
  LampiBoardColorsCharacteristic.super_.call(this, {
    uuid: '0002A7D3-D8A4-4FEA-8174-1736E808C067',
    properties: ['read'],
    secure: [],
    descriptors: [
        new bleno.Descriptor({
            uuid: '2901',
            value: CHARACTERISTIC_NAME,
        }),
        new bleno.Descriptor({
           uuid: '2904',
           value: new Buffer([0x07, 0x00, 0x27, 0x00, 0x01, 0x00, 0x00])
        }),
    ],
  });

  this._update = null;

//  this.changed_board_colors =  function(color_list) {
  //  console.log('lampiState changed LampiHSVCharacteristic');
    //if( this._update !== null ) {
      //  var data = new Buffer(color_list);
       // this._update(data);
 //   }
 // }

  this.lampiState = lampiState;

//  this.lampiState.on('changed_board_color', this.changed_board_colors.bind(this));

}

util.inherits(LampiBoardColorsCharacteristic, bleno.Characteristic);

LampiBoardColorsCharacteristic.prototype.onReadRequest = function(offset, callback) {
  console.log('onReadRequest');
  if (offset) {
    console.log('onReadRequest offset');
    callback(this.RESULT_ATTR_NOT_LONG, null);
  }
  else {
    var data_arr = []
    var data = new Buffer(25);
    for (i=0; i< 25; i++){
        data.writeUInt8(this.lampiState.board_colors[i].charCodeAt(0), i);
    }
    console.log(data)
    callback(this.RESULT_SUCCESS, data);
  }
};

LampiBoardColorsCharacteristic.prototype.onSubscribe = function(maxValueSize, updateValueCallback) {
    console.log('subscribe on ', CHARACTERISTIC_NAME);
    this._update = updateValueCallback;
}

LampiBoardColorsCharacteristic.prototype.onUnsubscribe = function() {
    console.log('unsubscribe on ', CHARACTERISTIC_NAME);
    this._update = null;
}

module.exports = LampiBoardColorsCharacteristic;

