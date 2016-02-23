
Wordpress boilerplate for Google App Engine deployment
======================================================

This is a Wordpress installation boilerplate prepared specifically for easy 
Wordpress core and plugins updating via composer.

Learn more about composer-powered wordpress [here](https://roots.io/using-composer-with-wordpress/).

Contains configure script for easy configs update for Google App Engine deployment.

You can learn about installing WP on GAE [here](https://googlecloudplatform.github.io/appengine-php-wordpress-starter-project/).
Problem with original [google’s boilerplate](https://github.com/GoogleCloudPlatform/appengine-php-wordpress-starter-project)
 is that you have to use git submodules to update WP core and plugins, and it quickly becomes hard to maintain.

Includes [Timber](http://upstatement.com/timber/) for easy template creation with Twig support.


## Step 0. Composer

1.  Get [composer](https://getcomposer.org/doc/00-intro.md):

        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

2. To install WP core and plugins, simply launch:

        composer install

    or, to update installed:

        composer update


## GAE Prerequisites

1. Install the [PHP SDK for Google App Engine](https://developers.google.com/appengine/downloads#Google_App_Engine_SDK_for_PHP)
2. Install [MySQL](http://dev.mysql.com/downloads/)
3. [Sign up](http://cloud.google.com/console) for a Google Cloud Platform project, and
set up a Cloud SQL instance, as described [here](https://cloud.google.com/sql/docs/getting-started#create), and a
Cloud Storage bucket, as described [here](https://developers.google.com/storage/docs/signup).
Remember the name of your Cloud SQL instance to fill configuration values later. 
To keep costs down, we suggest signing up for a D0 instance with package billing. 




## Automated configuration

Just run

    sh configure.sh

## Manual configuration

Copy `wp-config-default.php` to `wp-config.php` and edit it replacing DB settings.
 Add random string in AUTH_KEY, SECURE_AUTH_KEY, etc. section.

Copy `app-default.yaml` to `app.yaml` and edit replacing App ID and version. 


## GAE deployment

    $ APP_ENGINE_SDK_PATH/appcfg.py update APPLICATION_DIRECTORY

#### Activating the plugins

Now, we just need to activate the plugins that were packaged with your app. Log into the WordPress
administration section of your blog at `http://<PROJECT_ID>.appspot.com/wp-admin`, and visit the
Plugins section. Click the links to activate **Batcache Manager** and **Google App Engine for WordPress**.


## Non-GAE deployment

This package is not intended to deploy Wordpress anywhere except Google App Engine.

If you want to deploy to Digital Ocean, Amazon, etc., use [Bedrock](https://github.com/roots/bedrock) from roots.io.


## Local dev server

To run WordPress locally on Windows and OS X, you can use the
[Launcher](https://developers.google.com/appengine/downloads#Google_App_Engine_SDK_for_PHP)
by going to **File > Add Existing Project** or you can run one of the commands below.

On Mac and Windows, the default is to use the PHP binaries bundled with the SDK:

    $ APP_ENGINE_SDK_PATH/dev_appserver.py path_to_this_directory

On Linux, or to use your own PHP binaries, use:

    $ APP_ENGINE_SDK_PATH/dev_appserver.py --php_executable_path=PHP_CGI_EXECUTABLE_PATH path_to_this_directory

Now, with App Engine running locally, visit `http://localhost:8080/wp-admin/install.php` in your browser and run
the setup process, changing the port number from 8080 if you aren't using the default.

