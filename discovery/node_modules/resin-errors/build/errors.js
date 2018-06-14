"use strict";
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
Object.defineProperty(exports, "__esModule", { value: true });
var tslib_1 = require("tslib");
/**
 * @module errors
 */
var TypedError = require("typed-error");
var ResinError = (function (_super) {
    tslib_1.__extends(ResinError, _super);
    function ResinError() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    return ResinError;
}(TypedError));
exports.ResinError = ResinError;
ResinError.prototype.code = 'ResinError';
ResinError.prototype.exitCode = 1;
/**
 * @summary Resin invalid device type
 * @class
 * @public
 *
 * @param {String} type - device type
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinInvalidDeviceType('raspberry-pi')
 */
var ResinInvalidDeviceType = (function (_super) {
    tslib_1.__extends(ResinInvalidDeviceType, _super);
    function ResinInvalidDeviceType(type) {
        var _this = _super.call(this, "Invalid device type: " + type) || this;
        _this.type = type;
        return _this;
    }
    return ResinInvalidDeviceType;
}(ResinError));
exports.ResinInvalidDeviceType = ResinInvalidDeviceType;
ResinInvalidDeviceType.prototype.code = 'ResinInvalidDeviceType';
/**
 * @summary Resin discontinued device type
 * @class
 * @public
 *
 * @description
 * The device type that you specified is invalid because it is
 * discontinued, and this operation is no longer supported.
 *
 * @param {String} type - device type
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinDiscontinuedDeviceType('edge')
 */
var ResinDiscontinuedDeviceType = (function (_super) {
    tslib_1.__extends(ResinDiscontinuedDeviceType, _super);
    function ResinDiscontinuedDeviceType(type) {
        var _this = _super.call(this, "Discontinued device type: " + type) || this;
        _this.type = type;
        return _this;
    }
    return ResinDiscontinuedDeviceType;
}(ResinInvalidDeviceType));
exports.ResinDiscontinuedDeviceType = ResinDiscontinuedDeviceType;
ResinDiscontinuedDeviceType.prototype.code = 'ResinDiscontinuedDeviceType';
/**
 * @summary Resin malformed token
 * @class
 * @public
 *
 * @param {String} token - token
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinMalformedToken('1234')
 */
var ResinMalformedToken = (function (_super) {
    tslib_1.__extends(ResinMalformedToken, _super);
    function ResinMalformedToken(token) {
        var _this = _super.call(this, "Malformed token: " + token) || this;
        _this.token = token;
        return _this;
    }
    return ResinMalformedToken;
}(ResinError));
exports.ResinMalformedToken = ResinMalformedToken;
ResinMalformedToken.prototype.code = 'ResinMalformedToken';
/**
 * @summary The device supervisor is locked
 * @class
 * @public
 *
 * @param {String} token - token
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinSupervisorLockedError()
 */
var ResinSupervisorLockedError = (function (_super) {
    tslib_1.__extends(ResinSupervisorLockedError, _super);
    function ResinSupervisorLockedError(token) {
        var _this = _super.call(this, "Supervisor Locked: " + token) || this;
        _this.token = token;
        return _this;
    }
    return ResinSupervisorLockedError;
}(ResinError));
exports.ResinSupervisorLockedError = ResinSupervisorLockedError;
ResinSupervisorLockedError.prototype.code = 'ResinSupervisorLockedError';
/**
 * @summary Resin expired token
 * @class
 * @public
 *
 * @param {String} token - token
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinExpiredToken('1234')
 */
var ResinExpiredToken = (function (_super) {
    tslib_1.__extends(ResinExpiredToken, _super);
    function ResinExpiredToken(token) {
        var _this = _super.call(this, "The token expired: " + token) || this;
        _this.token = token;
        return _this;
    }
    return ResinExpiredToken;
}(ResinError));
exports.ResinExpiredToken = ResinExpiredToken;
ResinExpiredToken.prototype.code = 'ResinExpiredToken';
/**
 * @summary Resin application not found
 * @class
 * @public
 *
 * @param {(String|Number)} application - application name or id
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinApplicationNotFound('MyApp')
 */
var ResinApplicationNotFound = (function (_super) {
    tslib_1.__extends(ResinApplicationNotFound, _super);
    function ResinApplicationNotFound(application) {
        var _this = _super.call(this, "Application not found: " + application) || this;
        _this.application = application;
        return _this;
    }
    return ResinApplicationNotFound;
}(ResinError));
exports.ResinApplicationNotFound = ResinApplicationNotFound;
ResinApplicationNotFound.prototype.code = 'ResinApplicationNotFound';
/**
 * @summary Resin build not found
 * @class
 * @public
 * @deprecated From the new v4 API, ResinReleaseNotFound should be used instead
 *
 * @param {(Number)} build - build id
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinBuildNotFound(123)
 */
var ResinBuildNotFound = (function (_super) {
    tslib_1.__extends(ResinBuildNotFound, _super);
    function ResinBuildNotFound(build) {
        var _this = _super.call(this, "Build not found: " + build) || this;
        _this.build = build;
        return _this;
    }
    return ResinBuildNotFound;
}(ResinError));
exports.ResinBuildNotFound = ResinBuildNotFound;
ResinBuildNotFound.prototype.code = 'ResinBuildNotFound';
/**
 * @summary Resin release not found
 * @class
 * @public
 *
 * @param {(Number)} release - release id
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinReleaseNotFound(123)
 */
var ResinReleaseNotFound = (function (_super) {
    tslib_1.__extends(ResinReleaseNotFound, _super);
    function ResinReleaseNotFound(release) {
        var _this = _super.call(this, "Release not found: " + release) || this;
        _this.release = release;
        return _this;
    }
    return ResinReleaseNotFound;
}(ResinError));
exports.ResinReleaseNotFound = ResinReleaseNotFound;
ResinReleaseNotFound.prototype.code = 'ResinReleaseNotFound';
/**
 * @summary Resin image not found
 * @class
 * @public
 *
 * @param {(Number)} image - image id
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinImageNotFound(123)
 */
var ResinImageNotFound = (function (_super) {
    tslib_1.__extends(ResinImageNotFound, _super);
    function ResinImageNotFound(image) {
        var _this = _super.call(this, "Image not found: " + image) || this;
        _this.image = image;
        return _this;
    }
    return ResinImageNotFound;
}(ResinError));
exports.ResinImageNotFound = ResinImageNotFound;
ResinImageNotFound.prototype.code = 'ResinImageNotFound';
/**
 * @summary Resin service not found
 * @class
 * @public
 *
 * @param {(Number)} service - service id
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinServiceNotFound(123)
 */
var ResinServiceNotFound = (function (_super) {
    tslib_1.__extends(ResinServiceNotFound, _super);
    function ResinServiceNotFound(service) {
        var _this = _super.call(this, "Service not found: " + service) || this;
        _this.service = service;
        return _this;
    }
    return ResinServiceNotFound;
}(ResinError));
exports.ResinServiceNotFound = ResinServiceNotFound;
ResinServiceNotFound.prototype.code = 'ResinServiceNotFound';
/**
 * @summary Resin device not found
 * @class
 * @public
 *
 * @param {(String|Number)} device - device name or id
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinDeviceNotFound('MyDevice')
 */
var ResinDeviceNotFound = (function (_super) {
    tslib_1.__extends(ResinDeviceNotFound, _super);
    function ResinDeviceNotFound(device) {
        var _this = _super.call(this, "Device not found: " + device) || this;
        _this.device = device;
        return _this;
    }
    return ResinDeviceNotFound;
}(ResinError));
exports.ResinDeviceNotFound = ResinDeviceNotFound;
ResinDeviceNotFound.prototype.code = 'ResinDeviceNotFound';
/**
 * @summary Resin ambiguous device
 * @class
 * @public
 *
 * @param {(String|Number)} device - device name or id
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinAmbiguousDevice('MyDevice')
 */
var ResinAmbiguousDevice = (function (_super) {
    tslib_1.__extends(ResinAmbiguousDevice, _super);
    function ResinAmbiguousDevice(device) {
        var _this = _super.call(this, "Device is ambiguous: " + device) || this;
        _this.device = device;
        return _this;
    }
    return ResinAmbiguousDevice;
}(ResinError));
exports.ResinAmbiguousDevice = ResinAmbiguousDevice;
ResinAmbiguousDevice.prototype.code = 'ResinAmbiguousDevice';
/**
 * @summary Resin ambiguous application
 * @class
 * @public
 *
 * @param {(String|Number)} application - application name or id
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinAmbiguousApplication('MyApp')
 */
var ResinAmbiguousApplication = (function (_super) {
    tslib_1.__extends(ResinAmbiguousApplication, _super);
    function ResinAmbiguousApplication(application) {
        var _this = _super.call(this, "Application is ambiguous: " + application) || this;
        _this.application = application;
        return _this;
    }
    return ResinAmbiguousApplication;
}(ResinError));
exports.ResinAmbiguousApplication = ResinAmbiguousApplication;
ResinAmbiguousApplication.prototype.code = 'ResinAmbiguousApplication';
/**
 * @summary Resin key not found
 * @class
 * @public
 *
 * @param {(String|Number)} key - key name, id or value
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinKeyNotFound('MyKey')
 */
var ResinKeyNotFound = (function (_super) {
    tslib_1.__extends(ResinKeyNotFound, _super);
    function ResinKeyNotFound(key) {
        return _super.call(this, "Key not found: " + key) || this;
    }
    return ResinKeyNotFound;
}(ResinError));
exports.ResinKeyNotFound = ResinKeyNotFound;
ResinKeyNotFound.prototype.code = 'ResinKeyNotFound';
/**
 * @summary Resin request error
 * @class
 * @public
 *
 * @param {String} body - response body
 * @param {Number} statusCode - http status code
 * @param {Object} [requestOptions] - options used to make the request
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinRequestError('Unauthorized')
 */
var ResinRequestError = (function (_super) {
    tslib_1.__extends(ResinRequestError, _super);
    function ResinRequestError(body, statusCode, requestOptions) {
        var _this = _super.call(this, "Request error: " + body) || this;
        _this.body = body;
        _this.statusCode = statusCode;
        _this.requestOptions = requestOptions;
        return _this;
    }
    return ResinRequestError;
}(ResinError));
exports.ResinRequestError = ResinRequestError;
ResinRequestError.prototype.code = 'ResinRequestError';
/**
 * @summary Resin not logged in
 * @class
 * @public
 *
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinNotLoggedIn()
 */
var ResinNotLoggedIn = (function (_super) {
    tslib_1.__extends(ResinNotLoggedIn, _super);
    function ResinNotLoggedIn() {
        return _super.call(this, 'You have to log in') || this;
    }
    return ResinNotLoggedIn;
}(ResinError));
exports.ResinNotLoggedIn = ResinNotLoggedIn;
ResinNotLoggedIn.prototype.code = 'ResinNotLoggedIn';
/**
 * @summary Resin invalid parameter
 * @class
 * @public
 *
 * @return {Error} error instance
 *
 * @example
 * const checkId = (id) => {
 * 	if (typeof id !== 'number') {
 * 		throw new errors.ResinInvalidParameterError('id', id)
 * 	}
 * }
 */
var ResinInvalidParameterError = (function (_super) {
    tslib_1.__extends(ResinInvalidParameterError, _super);
    function ResinInvalidParameterError(parameterName, suppliedValue) {
        var _this = _super.call(this, "Invalid parameter: " + suppliedValue + " is not a valid value for parameter '" + parameterName + "'") || this;
        _this.parameterName = parameterName;
        _this.suppliedValue = suppliedValue;
        return _this;
    }
    return ResinInvalidParameterError;
}(ResinError));
exports.ResinInvalidParameterError = ResinInvalidParameterError;
ResinInvalidParameterError.prototype.code = 'ResinInvalidParameterError';
//# sourceMappingURL=errors.js.map