 <?php 
 
require("phpsqlinfo_dbinfo.php");

$connection = mysql_connect ($host, $username, $password);
if (!$connection) {
  die('Not connected : ' . mysql_error());
}
 //Set the active MySQL database
$db_selected = mysql_select_db($database, $connection);
if (!$db_selected) {
  die ('Can\'t use db : ' . mysql_error());
}

$var_order = $_GET['ord'];
$var_order_ref = $_GET['ref'];

//$var_order = "2,9";
if (empty($var_order))
    $var_sql = "";
else
     $var_sql = "select * from 0_locations where loc_code in (".$var_order.")";
 
echo($var_sql);
?>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <style>
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      #map {
        height: 100%;
      }
.controls {
  margin-top: 10px;
  border: 1px solid transparent;
  border-radius: 2px 0 0 2px;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  height: 32px;
  outline: none;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
}

#pac-input {
  background-color: #fff;
  font-family: Roboto;
  font-size: 15px;
  font-weight: 300;
  margin-left: 12px;
  padding: 0 11px 0 13px;
  text-overflow: ellipsis;
  width: 300px;
}

#pac-input:focus {
  border-color: #4d90fe;
}

.pac-container {
  font-family: Roboto;
}

#type-selector {
  color: #fff;
  background-color: #4d90fe;
  padding: 5px 11px 0px 11px;
}

#type-selector label {
  font-family: Roboto;
  font-size: 13px;
  font-weight: 300;
}

    </style>
    <title>Places Searchbox</title>
    <style>
      #target {
        width: 345px;
      }
    </style>
    
<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDY0kkJiTPVd2U7aTOAwhc9ySH6oHxOIYM&sensor=false&libraries=places&callback=initAutocomplete"></script>
<script type="text/javascript">
    var markers = [];
    var uniqueId = 1;
    window.onload = function () {
        var mapOptions = {
            center: new google.maps.LatLng(21.0000, 78.0000),
            zoom: 5,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var map = new google.maps.Map(document.getElementById("dvMap"), mapOptions);
 
        <?php
if (!empty($var_sql))
{
  $var_result = mysql_query($var_sql);
    while($var_row = mysql_fetch_array($var_result))
    {
          $var_lat = $var_row['latitude'] ;    
         $var_lon = $var_row['longitude'];  
       ?>
         var marker1 = new google.maps.Marker({
        position: new google.maps.LatLng(<?=$var_lat?>,<?=$var_lon?>),
        map: map,
        title: 'Hello World!'
        });
    <?php 
    }
}
?> 
        
        // searching location
        // Create the search box and link it to the UI element.
  var input = document.getElementById('pac-input');
  var searchBox = new google.maps.places.SearchBox(input);
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);


  // Bias the SearchBox results towards current map's viewport.
  map.addListener('bounds_changed', function() {
    searchBox.setBounds(map.getBounds());
  });
// [START region_getplaces]
  // Listen for the event fired when the user selects a prediction and retrieve
  // more details for that place.
  searchBox.addListener('places_changed', function() {
    var places = searchBox.getPlaces();

    if (places.length == 0) {
      return;
    }
    
        // For each place, get the icon, name and location.
    var bounds = new google.maps.LatLngBounds();
    places.forEach(function(place) {
      var icon = {
        url: place.icon,
        size: new google.maps.Size(71, 71),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(17, 34),
        scaledSize: new google.maps.Size(25, 25)
      };

      // Create a marker for each place.
//      markers.push(new google.maps.Marker({
//        map: map,
//        icon: icon,
//        title: place.name,
//        position: place.geometry.location
//      }));


//Attach click event handler to the map.
        //google.maps.event.addListener(map, 'click', function (e) {
 
            //Determine the location where the user has clicked.
            //var location = e.latLng;
 
            //Create a marker and placed it on the map.
            var marker = new google.maps.Marker({
                position: place.geometry.location,
                map: map
            });
 
            //Set unique id
            marker.id = uniqueId;
            uniqueId++;
    
        var location = marker.getPosition();
            //Attach click event handler to the marker.
            google.maps.event.addListener(marker, "click", function (e) {
                var content = 'Latitude: ' + location.lat() + '<br />Longitude: ' + location.lng();
                content += "<br /><input type = 'button' va;ue = 'Delete' onclick = 'DeleteMarker(" + marker.id + ", <?=$var_order_ref?>);' value = 'Delete' />\n\
                <input type = 'button' id ='Save' name='Save' value = 'Save' onclick = 'SaveMarker("+location.lat()+ ","+location.lng()+"," + marker.id +", <?=$var_order_ref?>);'  />\n\
</br><div id = 'addedmsg'></div>";
                    
                var infoWindow = new google.maps.InfoWindow({
                    content: content
                });
                infoWindow.open(map, marker);
            });
 
            //Add marker to the array.
            markers.push(marker);
        //});

      if (place.geometry.viewport) {
        // Only geocodes have viewport.
        bounds.union(place.geometry.viewport);
      } else {
        bounds.extend(place.geometry.location);
      }
    });
    map.fitBounds(bounds);
  });
  // [END region_getplaces]
    
    
    };
    
    function DeleteMarker(id,order_ref) {
        //Find and remove the marker from the Array
        for (var i = 0; i < markers.length; i++) {
            if (markers[i].id == id) {
                //Remove the marker from Map                  
                markers[i].setMap(null);
 
                //Remove the marker from array.
                markers.splice(i, 1);
                var url = "phpsqlinfo_deleterow.php?marker_id=" + id+ "&order_ref="+order_ref;
        
                downloadUrl(url, function(data, responseCode) {
                document.getElementById(addedmsg).innerHTML  =  'Location deleted';

                })
                
                return;
            }
        }
    };
    
    
    function SaveMarker(lati,long,markerid,order_ref) {
        
       // alert('inside : ' +document.getElementById("Location Saved").value);
      var name = escape(document.getElementById("pac-input").value);
      var address = escape(document.getElementById("pac-input").value);
      var type = document.getElementById("pac-input").value;
      
        //      var latlng = mark.getPosition();

      var url = "phpsqlinfo_addrow.php?name=" + name + "&address=" + address +
                "&type=" + type + "&lat=" + lati + "&lng=" + long +"&marker_id=" + markerid+ "&order_ref="+order_ref;
        
      downloadUrl(url, function(data, responseCode) {
        //if (responseCode == 200 || data.length >= 1) {
            alert("Location Added");
            //document.getElementById("message").innerHTML =  "Location added.";
            document.getElementById(addedmsg).innerHTML  =  'Location added';
            infoWindow.close();
            
        //}
      })
      
    }
    function downloadUrl(url, callback) {
      var request = window.ActiveXObject ?
          new ActiveXObject('Microsoft.XMLHTTP') :
          new XMLHttpRequest;

      request.onreadystatechange = function() {
        if (request.readyState == 4) {
          request.onreadystatechange = doNothing;
          callback(request.responseText, request.status);
        }
      };

      request.open('GET', url, true);
      request.send(null);
    }

    function doNothing() {}

</script>
</head>
<body>
    <input id="pac-input" class="controls" type="text" placeholder="Search Box">
    <div id="message"></div>
    <div id="dvMap" style="width: 500px; height: 500px"></div>
</body>
</html>