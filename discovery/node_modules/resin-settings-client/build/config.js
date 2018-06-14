"use strict";
/*
Copyright 2016-17 Resin.io

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
var hidepath = require("hidepath");
var userHome = require("home-or-tmp");
var path_1 = require("path");
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
        user: path_1.join(userHome, hidepath('resinrc.yml')),
        /**
         * @property {String} project - path to project config
         * @memberof paths
         */
        project: path_1.join(process.cwd(), 'resinrc.yml')
    }
};
//# sourceMappingURL=config.js.map