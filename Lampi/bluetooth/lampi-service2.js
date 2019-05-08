var util = require('util');
var bleno = require('bleno');

var LampiBoardColorsCharacteristic = require('./lampi-boardcolors-characteristic');

function LampiService(lampiState) {
    console.log("Start Lampi Service")
    bleno.PrimaryService.call(this, {
        uuid: '0001A7D3-D8A4-4FEA-8174-1736E808C067',
        characteristics: [
            new LampiBoardColorsCharacteristic(lampiState),
        ]
    });
}

util.inherits(LampiService, bleno.PrimaryService);

module.exports = LampiService;
