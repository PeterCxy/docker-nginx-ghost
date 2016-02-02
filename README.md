docker-nginx-ghost
---
This is a Docker image for running Nginx + Ghost as a service. Ghost is a blog system, while Nginx acts as a reverse proxy to Ghost. As many services like Gravatar cannot be correctly loaded from China, the Nginx replaces them with an accessible proxy using `http_sub` module. It also helps processing HTTPS meta links in Ghost.

Usage
---
After building the image, just run

```bash
docker run -v /path/to/your/data:/mnt/volume -e ENV1=value -e ... your-image-id
```

To save the blog data, a Docker image is needed to be mounted into the container. If it is mounted at `/usr/src/ghost/content`, then the whole volume will act as the content storage for Ghost. However, in many CaaS providers like DaoCloud, one volume may be shared across several containers. In this case, you can mount the volume to another path like `/mnt/volume`, and point the environment variable `GHOST_SITE_DATA` to the full path of the data storage like `/mnt/volume/ghost_content`.

There are more environment variables to set:

`GHOST_SITE_HTTPS` - Whether this site should force its urls to begin with `https`. Set to `true` to enable it.  
`GHOST_SITE_URL` - Full url to this site without the scheme. e.g. `typeblog.net`
`GHOST_MAILGUN_USER` & `GHOST_MAILGUN_PASS` - __REQUIRED__ [Mailgun](http://www.mailgun.com/) API credentials.
