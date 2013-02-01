# GoogleAnalytics

The GoogleAnalytics Plugin is a Movable Type plugin that allows users with access to the Dashboard for a Movable Type blog to see Sessions, Page View, and Visitors statistics about the blog as reported by Google Analytics.

Charts representing these three categories of statistics are automatically added to the "Blog Stats" widget provided that the blog-level plugin settings are set in the manner described below, and the Google Analytics User Name and Password represent a valid set of credentials associated with a Google Analytics account.

# Installation

After downloading and uncompressing this package:

1. Upload the entire GoogleAnalytics directory within the plugins directory of this distribution to the corresponding plugins directory within the Movable Type installation directory.
    * UNIX example:
        * Copy mt-plugin-google-analytics/plugins/GoogleAnalytics/ into /var/wwww/cgi-bin/mt/plugins/.
    * Windows example:
        * Copy mt-plugin-google-analytics/plugins/GoogleAnalytics/ into C:\webroot\mt-cgi\plugins\ .
2. This plugin currently has no resources that need to be installed in the mt-static directory of your instance of Movable Type, so there is no action to take in this step.

# Post-Installation

Please note that this plugin makes no database schema changes, which generally triggers display of a message similar to this: "Time to Upgrade!  A new version of Movable Type has been installed. We'll need to complete a few tasks to update your database...."

In addition, this plugin does not display anything in the Blog Stats widget on the Dashboard until the steps discussed in the Configuration section below are completed.

# Configuration

The following configuration needs to be completed for each blog in your Movable Type instance in which you want the Blog Stats widget to display statistics from Google Analytics:

1. Login to your Movable Type instance at http://www.mywebsite.com/cgi-bin/mt/mt.cgi.
2. Visit the "Blog Plugin Settings" page at http://www.mywebsite.com/cgi-bin/mt/mt.cgi?__mode=cfg_plugins&blog_id=x, where "x" is the ID number of the blog that you want to configure.
3. Click on the "Google Analytics" item in the list on the Blog Plugin Settings page.  Then, choose the "Settings" tab to display the configuration parameters that must be completed before the plugin will function.
4. Enter your Google Analytics Username, Google Analyics Password, and Google Analytics Profile ID in the appropriate fields.  The information that must be provided is as follows:
    * Google Analytics Username
        * This form field contains an email address associated with the Google Analytics account that contains the website on which statistics are to be reported.
    * Google Analytics Password
        * This form field contains the corresponding password for this Google Analytics account.
    * Google Analytics Profile ID
        * This form field contains the profile ID for the website on which statistics are to be reported.  The Profile ID is contained in the Profile Settings tab of the Profile page within the Admin section of the Google Analytics website.
        * **NOTE**: In many cases, this Profile ID is an eight-digit number (for example: 12345678).  It is specifically not the Property ID, which often has the form UA-123456-7.
    * When these fields are properly completed, press the "Save Changes" button.

**Note**: In the event that you must edit the values you entered in the instructions listed above, we recommend that you press the "Reset to Defaults" button, and re-enter the information for all three fields as discussed in step 4.

**Note**: If your Google Analytics Username is also an email address at Gmail.com (Google Mail), please note that you are likely to receive a "Suspicious sign in prevented" message from Google, which begins in the following manner: "User First Name, Someone recently tried to use an application to sign in to your Google Account - yourgoogleaccount@gmail.com. We prevented the sign-in attempt in case this was a hijacker trying to access your account. Please review the details of the sign-in attempt...."  If you receive this message, you should read and complete the troubleshooting steps described by Google in http://support.google.com/mail?p=client_login.

# Usage

## Template Tags

GoogleAnalytics does not implement any new tags.


# Support

This plugin has not been tested by After6 Services with any version of Movable Type prior to Movable Type 4.38.  This plugin is known by After6 Services to be compatible with Movable Type Version 5.x up to at least 5.2.2.

Although After6 Services LLC has assisted with the development and documentation of this plugin, After6 only provides support for this plugin as part of a Movable Type technical support agreement that references this plugin by name.

# License

This plugin is licensed under the MIT License which some people also refer to as the Expat License, http://opensource.org/licenses/mit-license.php.  See LICENSE.md for the exact license.

# Authorship

GoogleAnalytics was originally written by Okayama Kenmin.  Documentation and help with English localization was provided by Dave Aiello from After6 Services.

# Copyright

Copyright &copy; 2010, Okayama Kenmin.  All Rights Reserved.
Copyright &copy; 2013, After6 Services LLC.  All Rights Reserved.

Movable Type is a registered trademark of Six Apart Limited.
Google Analytics web analytics service is a registered trademark of Google Inc.

Trademarks, product names, company names, or logos used in connection with this repository are the property of their respective owners and references do not imply any endorsement, sponsorship, or affiliation with After6 Services LLC unless otherwise specified.
