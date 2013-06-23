# Slapme

Slapme generates a batman comic panel where batman slaps robin using the given text lines. This is the original:

![batman](http://goodcomics.comicbookresources.com/wp-content/uploads/2009/01/batslapper.jpg)

Slapme accepts POST requests with two parameters, ``robin`` and ``batman`` and returns a JSON response including the url of the generated image.

Here is an example request:

    POST /slaps.json

    robin=Hi%20Batman&batman=Shut%20Up

and here is an example response:

    HTTP/1.1 200 OK

    {"url":"http://<host>/slaps/d1104c6999b9262610ad15967e1b7e357dcef53e.jpg"}

## Settings

Copy ``config/examples/settings.yml`` into ``config/settings.yml`` and modify to customize the following:

* ``base_uri`` used to generate slap urls
* ``storage`` section containing settings for each different supported storage (e.g. file_system)
  * ``file_system`` stores image files locally in the specified ``path``

Example:

```
base_uri: http://localhost:9292

storage:
  file_system:
    path: '/tmp/slapme/files'
```
