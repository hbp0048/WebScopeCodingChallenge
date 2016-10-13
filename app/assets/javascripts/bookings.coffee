###

Coffeescript related to Booking. Contains functionality that allows autocomplete function, 
showing address onto the map and calculating distance and time between two locations

Created by: Minju Park
Last edited in: 13/10/2016

###


jQuery(document).on 'turbolinks:load', ->
    google_map = $('#googleMap')
    
    # if map element is not shown in the page, javascript functions below shouldnt work
    if google_map.length > 0
        
        #initialise map related variables
        map = new google.maps.Map(document.getElementById("googleMap"), {
            center: {lat: -36.788426, lng: 174.771742},
            zoom: 13
        })
        
        markersArray = [];
        
        pickupIcon = 'https://chart.googleapis.com/chart?' +
            'chst=d_map_pin_letter&chld=P|FF0000|000000'
        dropoffIcon = 'https://chart.googleapis.com/chart?' +
            'chst=d_map_pin_letter&chld=D|FFFF00|000000'
            
        
        geocoder = new google.maps.Geocoder
        bounds = new google.maps.LatLngBounds
        service = new google.maps.DistanceMatrixService()
        
        ########### add autocomplete function into address related input fields #####################
        pickup_input = document.getElementById("pickup-address")
        dropoff_input = document.getElementById("dropoff-address")
        
        pickup_autocomplete = new google.maps.places.Autocomplete(pickup_input)
        pickup_autocomplete.bindTo('bounds', map)
        # set types of autocomplete it can be all([]), geocode(['geocode']), establishment (['establishment']), address(['address'])
        pickup_autocomplete.setTypes([])
        
        dropoff_autocomplete = new google.maps.places.Autocomplete(dropoff_input)
        dropoff_autocomplete.bindTo('bounds', map)
        dropoff_autocomplete.setTypes([])
        
        
        ########## changes the map view when user selects the autocomplete pickup address #################
        info_window = new google.maps.InfoWindow()
        markerA = new google.maps.Marker({
            map: map,
            anchorPoint: new google.maps.Point(0, -29)
        })
        
        markerB = new google.maps.Marker({
            map: map,
            anchorPoint: new google.maps.Point(0, -29)
        })
        
        # events fires to change the map view when user selects the autocomplete pickup address 
        pickup_autocomplete.addListener 'place_changed', ->
            info_window.close()
            markerA.setVisible(false)
            place = pickup_autocomplete.getPlace()
            if (!place.geometry) 
                window.alert("Autocomplete's returned place contains no geometry")
                return
            
            # when the pickup address input has a geometry then show it on the map
            if place.geometry.viewport
                map.fitBounds(place.geometry.viewport)
            else
                map.setCenter(place.geometry.location)
                map.setZoom(17)
            
            markerA.setIcon(({
                url: place.icon,
                size: new google.maps.Size(70, 70),
                origin: new google.maps.Point(0,0),
                anchor: new google.maps.Point(17, 34),
                scaledSize: new google.maps.Size(35, 35)
            }))
            markerA.setPosition(place.geometry.location)
            markerA.setVisible(true)
            
            address = ''
            if(place.address_components)
                address = [
                    (place.address_components[0] && place.address_components[0].short_name || ''),
                    (place.address_components[1] && place.address_components[1].short_name || ''),
                    (place.address_components[2] && place.address_components[2].short_name || '')
                ].join(' ')
            
            info_window.setContent('<div><strong>' + place.name + '</strong><br>' + address)
        
        
        # events fires to change the map view when user selects the autocomplete dropoff address 
        dropoff_autocomplete.addListener 'place_changed', ->
            info_window.close()
            markerB.setVisible(false)
            place = dropoff_autocomplete.getPlace()
            if (!place.geometry) 
                window.alert("Autocomplete's returned place contains no geometry")
                return
            
            # when the drop-off address input has a geometry then show it on the map
            if place.geometry.viewport
                map.fitBounds(place.geometry.viewport)
            else
                map.setCenter(place.geometry.location)
                map.setZoom(17)
            
            markerB.setIcon(({
                url: place.icon,
                size: new google.maps.Size(70, 70),
                origin: new google.maps.Point(0,0),
                anchor: new google.maps.Point(17, 34),
                scaledSize: new google.maps.Size(35, 35)
            }))
            markerB.setPosition(place.geometry.location)
            markerB.setVisible(true)
            
            address = ''
            if(place.address_components)
                address = [
                    (place.address_components[0] && place.address_components[0].short_name || ''),
                    (place.address_components[1] && place.address_components[1].short_name || ''),
                    (place.address_components[2] && place.address_components[2].short_name || '')
                ].join(' ')
            
            info_window.setContent('<div><strong>' + place.name + '</strong><br>' + address)
        
        
        ##### function to get the distance and the time it will take between pickup location and dropoff location ####
        getDistanceAndTime = ->
            service.getDistanceMatrix({
                origins: [pickup_input.value]
                destinations: [dropoff_input.value]
                travelMode: google.maps.TravelMode.DRIVING,
                unitSystem: google.maps.UnitSystem.METRIC,
                avoidHighways: false,
                avoidTolls: false
            }, (response, status) ->
                if (status isnt 'OK')
                    alert('Error: ' + status)
                else 
                    originList = response.originAddresses
                    destinationList = response.destinationAddresses
                    deleteMarkers(markersArray)
                    
                    # place markers on the map if status returned is OK
                    showGeocodedAddressOnMap = (asDestination) ->
                        if asDestination is true
                            icon = dropoffIcon
                        else
                            icon = pickupIcon
                        return (results, status) ->
                            if(status is google.maps.GeocoderStatus.OK)
                                map.fitBounds(bounds.extend(results[0].geometry.location))
                                markersArray.push(new google.maps.Marker({
                                    map: map,
                                    position: results[0].geometry.location,
                                    icon: icon
                                }))
                            else
                                alert('Geocode was unsuccessful due to: ' + status)
            
            
                    results = response.rows[0].elements
                    
                    # place pickup and dropoff markers in the map
                    geocoder.geocode({'address': originList[0]}, showGeocodedAddressOnMap(false))
                    geocoder.geocode({'address': destinationList[0]}, showGeocodedAddressOnMap(true))
                    
                     # input the result(time) in the modal
                    $('#timeModal').modal("show")
                    $('.deliveryTime').text(originList[0] + ' to ' + destinationList[0] +
                        ': ' + results[0].distance.text + ' in ' +
                        results[0].duration.text )
                    
            )
        
        # delete markers so that when  user types new address it sets new markers from the array 
        deleteMarkers = (markersArray) ->
            for i in markersArray
                do (i) ->
                    i.setMap(null)
            markersArray=[]
            
        
        # add events to the button to return dstance and time information between pickup and dropoff
        $('.distanceTimeBtn').on 'click', (e)->
            e.preventDefault()
            getDistanceAndTime()
        
        # disable enter key 
        $('.form-group').on 'keyup keypress', (e) ->
            return e.which != 13  
        
        
        
