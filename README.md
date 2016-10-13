
This website allows users to make a booking for on-demand courier. By clicking 'Create' link in the index page, 
users can submit booking form.

Google Map API is incorporated so that users can auto complete their desired pickup and 
dropoff location more conveniently. 

After filling out pickup and drop-off information in the form, a user can see the distance and time it takes to 
deliver the courier between two locations. 

Cookies: cookies are used to store sender and last drop-off information 
so that drop-off location changes to pickup address next time the user creates a new booking.

Ruby on Rails framework was used to enable MVC for structural integration in the project.
Also, this allows easy maintenance, smooth scaling and adding functions.  
Tests are automatically generated for database model, controller and view so developers have no need to
manually create test files. 

* Ruby and Rails version
* 
Rails - 4.2.5
Ruby - 2.3.0

* Deployment instructions

Once you have Ruby on Rails set up and working, download the zip file and unzip to a desired location

``` 
$ cd <path>/WebScopeCodingChallenge-master
$ bundle install
$ rails db:migrate (or $ rake db:migrate)
$ rails server

```
Then open http://localhost:3000/

