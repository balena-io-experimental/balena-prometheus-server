console.log('discovery started')

var resin = require("resin-sdk")({
  apiUrl: "https://api.resin.io/"
})
var fs = require("fs")
var _ = require("lodash")

// console.log(process.env.RESIN_EMAIL)
// console.log(process.env.RESIN_PASS)
// console.log(process.env.RESIN_APP_NAME)

credentials = { email: process.env.RESIN_EMAIL, password: process.env.RESIN_PASS };

resin.auth.login(credentials, function(error) {
  if (error != null) {
    throw error;
  }

  console.log("Successfully authenticated with resin API")
  fetchResinDevices();
  setInterval(fetchResinDevices, process.env.DISCOVERY_INTERVAL);
});

function fetchResinDevices() {
  console.log("Fetching Resin devices");
  resin.models.device.getAllByApplication(process.env.RESIN_APP_NAME).then(function(devices) {
    // format array and save it as json file
    saveJson(_.map(devices, format));
  }).catch(function(error) {
    throw error;
  });
}

function saveJson(array) {
  fs.writeFile(__dirname + '/targets.json', JSON.stringify(array), 'utf8')
}

function format(device) {
  var url = device.uuid + ".resindevice.io:80"
   return {
    targets: [url],
    labels: {
      resin_device_uuid: device.uuid,
      resin_app: process.env.RESIN_APP_NAME,
      resin_device_name: device.name,
      resin_device_os_version: device.os_version,
      resin_device_commit: device.is_on__commit,
    }
  }
}
