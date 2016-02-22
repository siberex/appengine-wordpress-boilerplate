
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


## GAE Prerequisites

1. Install the [PHP SDK for Google App Engine](https://developers.google.com/appengine/downloads#Google_App_Engine_SDK_for_PHP)
2. Install [MySQL](http://dev.mysql.com/downloads/)
3. [Sign up](http://cloud.google.com/console) for a Google Cloud Platform project, and
set up a Cloud SQL instance, as described [here](https://cloud.google.com/sql/docs/getting-started#create), and a
Cloud Storage bucket, as described [here](https://developers.google.com/storage/docs/signup).
Remember the name of your Cloud SQL instance to fill configuration values later. 
To keep costs down, we suggest signing up for a D0 instance with package billing. 

