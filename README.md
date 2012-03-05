# Slapme

Slapme generates a batman comic panel where batman slaps robin using the given text lines. This is the original:

![batman](http://goodcomics.comicbookresources.com/wp-content/uploads/2009/01/batslapper.jpg)

Slapme accepts GET requests with two parameters, ``robin`` and ``batman``. It works in two different ways:

* HTTP redirect to the generated image

  ``/slapme?robin=Hi%20Batman&batman=Shut%20Up``
  
* JSON response including the url of the generated image

  ``/slapme.json?robin=Hi%20Batman&batman=Shut%20Up``

## Settings

Copy ``config/examples/settings.yml`` into ``config/settings.yml`` and modify to customize the following:

* ``images_path`` path to the directory on which to store generated slap images

