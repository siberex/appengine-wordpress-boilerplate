<?php
/**
 * Created by PhpStorm.
 * User: www.sib.li
 * Date: 24.02.16
 * Time: 03:23
 */

/**
 * Memcached plugin is replacing WP_Object_Cache class from wp/wp-includes/cache.php
 * so it should be loaded here.
 *
 * @link https://wordpress.org/plugins/memcached/installation/
 */
require_once __DIR__ . '/mu-plugins/Memcached-Object-Cache/object-cache.php';