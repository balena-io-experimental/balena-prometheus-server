
/*
Copyright 2016 Resin.io

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */
var hidepath, path, userHome;

path = require('path');

userHome = require('home-or-tmp');

hidepath = require('hidepath');


/**
 * @summary Configuration settings
 * @namespace config
 * @private
 */

module.exports = {

  /**
  	 * @summary Configuration paths
  	 * @namespace paths
  	 * @memberof config
   */
  paths: {

    /**
    		 * @property {String} user - path to user config
    		 * @memberof paths
     */
    user: path.join(userHome, hidepath('resinrc.yml')),

    /**
    		 * @property {String} project - path to project config
    		 * @memberof paths
     */
    project: path.join(process.cwd(), 'resinrc.yml')
  }
};
