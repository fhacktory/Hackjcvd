/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
function captureSuccess(mediaFiles) {
    var i, len;
    for (i = 0, len = mediaFiles.length; i < len; i += 1) {
        uploadFile(mediaFiles[i]);
    }
}

// Called if something bad happens.
//
function captureError(error) {
    var msg = 'An error occurred during capture: ' + error.code;
    navigator.notification.alert(msg, null, 'Uh oh!');
}

// A button will call this function
//
function captureVideo() {
    // Launch device video recording application,
    // allowing user to capture up to 2 video clips
    navigator.device.capture.captureVideo(captureSuccess, captureError, {limit: 2});
}

// Upload files to server
function uploadFile(mediaFile) {
    alert('i am done uploading file '+ mediaFile.name);
   /* var ft = new FileTransfer(),
    path = mediaFile.fullPath,
    name = mediaFile.name;
    
    ft.upload(path,
              "http://my.domain.com/upload.php",
              function(result) {
              console.log('Upload success: ' + result.responseCode);
              console.log(result.bytesSent + ' bytes sent');
              },
              function(error) {
              console.log('Error uploading file ' + path + ': ' + error.code);
              },
              { fileName: name });*/
}

/*var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
        app.initialize();
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        console.log('Received Event: ' + id);
    }
};



*/

Skip to content
This repository
Explore
Gist
Blog
Help
@tarte-au-sucre tarte-au-sucre

Watch 12
Star 33
Fork 27Wikitude/wikitude-phonegap-samples
branch: master  wikitude-phonegap-samples/SampleAppResources/js/index.js
rolandh-wikituderolandh-wikitude 20 days ago fixes crash (uncaught exception) on "Snapshot" in Phonegap samples 6.5
3 contributors rolandh-wikitudeAndreas Schacherbauer @WikitudeAndreas Schacherbauer
RawBlameHistory     105 lines (97 sloc)  4.046 kb
/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    
    // represents the device capability of launching ARchitect Worlds with specific features
isDeviceSupported: false,
    
    // Application Constructor
initialize: function() {
    this.bindEvents();
},
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
bindEvents: function() {
    document.addEventListener('deviceready', this.onDeviceReady, false);
},
    // deviceready Event Handler
onDeviceReady: function() {
    
    // check if the current device is able to launch ARchitect Worlds
    app.wikitudePlugin = cordova.require("com.wikitude.phonegap.WikitudePlugin.WikitudePlugin");
    app.wikitudePlugin.isDeviceSupported(function() {
                                         app.isDeviceSupported = true;
                                         }, function(errorMessage) {
                                         app.isDeviceSupported = false;
                                         alert('Unable to launch ARchitect Worlds on this device: \n' + errorMessage);
                                         },
                                         [app.wikitudePlugin.FeatureGeo, app.wikitudePlugin.Feature2DTracking]
                                         );
},
    // --- Wikitude Plugin ---
    // Use this method to load a specific ARchitect World from either the local file system or a remote server
loadARchitectWorld: function(example) {
    
    app.wikitudePlugin.setOnUrlInvokeCallback(app.onUrlInvoke);
    
    if (app.isDeviceSupported) {
        app.wikitudePlugin.loadARchitectWorld(function successFn(loadedURL) {
                                              /* Respond to successful world loading if you need to */
                                              }, function errorFn(error) {
                                              alert('Loading AR web view failed: ' + error);
                                              },
                                              example.path, example.requiredFeatures, example.startupConfiguration
                                              );
        
        // inject poi data using phonegap's GeoLocation API and inject data using World.loadPoisFromJsonData
        if ( example.requiredExtension === "ObtainPoiDataFromApplicationModel" ) {
            navigator.geolocation.getCurrentPosition(onLocationUpdated, onLocationError);
        }
    } else {
        alert("Device is not supported");
    }
},
urlLauncher: function(url) {
    var world = {
        "path": url,
        "requiredFeatures": [
                             "2d_tracking",
                             "geo"
                             ],
        "startupConfiguration": {
            "camera_position": "back"
        }
    };
    app.loadARchitectWorld(world);
},
    // This function gets called if you call "document.location = architectsdk://" in your ARchitect World
onUrlInvoke: function (url) {
    if (url.indexOf('captureScreen') > -1) {
        app.wikitudePlugin.captureScreen(
                                         function(absoluteFilePath) {
                                         alert("snapshot stored at:\n" + absoluteFilePath);
                                         },
                                         function (errorMessage) {
                                         alert(errorMessage);                
                                         },
                                         true, null
                                         );
    } else {
        alert(url + "not handled");
    }
}
    // --- End Wikitude Plugin ---
};

app.initialize();



