// This example displays an address form, using the autocomplete feature
// of the Google Places API to help users fill in the information.
initialize();
var placeSearch, autocomplete;
var componentForm = {
  locality: 'long_name',
  address: 'short_name'
};

function initialize() {
  // Create the autocomplete object, restricting the search
  // to geographical location types.
  autocomplete = new google.maps.places.Autocomplete(
      /** @type {HTMLInputElement} */(document.getElementById('autocomplete')),
      { types: ['geocode'] });
  // When the user selects an address from the dropdown,
  // populate the address fields in the form.
  google.maps.event.addListener(autocomplete, 'place_changed', function() {
    fillInAddress();
  });
}

// [START region_fillform]
function fillInAddress() {
  // Get the place details from the autocomplete object.
  var place = autocomplete.getPlace();

  for (var component in componentForm) {
    document.getElementById(component).value = '';
    document.getElementById(component).disabled = false;
  }
  var addressType = place.address_components[0]['long_name'];
  var shortLocality = place.address_components[0]['short_name'];

  var address = '';
  for(var i=1;i<place.address_components.length;i++)
  {
     address+= place.address_components[i]['long_name'] + "\n";
    }
  document.getElementById('locality').value = addressType;
   document.getElementById('address').value = address;
 // document.getElementById('short_locality').value = shortLocality

  }
// [END region_fillform]

// [START region_geolocation]
// Bias the autocomplete object to the user's geographical location,
// as supplied by the browser's 'navigator.geolocation' object.
function geolocate() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var geolocation = new google.maps.LatLng(
          position.coords.latitude, position.coords.longitude);
      var circle = new google.maps.Circle({
        center: geolocation,
        radius: position.coords.accuracy
      });
      autocomplete.setBounds(circle.getBounds());
    });
  }
}
// [END region_geolocation]
