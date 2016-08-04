
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

/**
 * @module errors
 */
var ResinAmbiguousApplication, ResinAmbiguousDevice, ResinApplicationNotFound, ResinDeviceNotFound, ResinExpiredToken, ResinInvalidDeviceType, ResinKeyNotFound, ResinMalformedToken, ResinNotLoggedIn, ResinRequestError, TypedError,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

TypedError = require('typed-error');


/**
 *	@summary Resin invalid device type
 * @class
 * @public
 *
 * @param {String} type - device type
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinInvalidDeviceType('raspberry-pi')
 */

exports.ResinInvalidDeviceType = ResinInvalidDeviceType = (function(_super) {
  __extends(ResinInvalidDeviceType, _super);

  function ResinInvalidDeviceType(type) {
    this.type = type;
    ResinInvalidDeviceType.__super__.constructor.call(this, "Invalid device type: " + this.type);
  }

  ResinInvalidDeviceType.prototype.code = 'ResinInvalidDeviceType';

  ResinInvalidDeviceType.prototype.exitCode = 1;

  return ResinInvalidDeviceType;

})(TypedError);


/**
 *	@summary Resin malformed token
 * @class
 * @public
 *
 * @param {String} token - token
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinMalformedToken('1234')
 */

exports.ResinMalformedToken = ResinMalformedToken = (function(_super) {
  __extends(ResinMalformedToken, _super);

  function ResinMalformedToken(token) {
    this.token = token;
    ResinMalformedToken.__super__.constructor.call(this, "Malformed token: " + this.token);
  }

  ResinMalformedToken.prototype.code = 'ResinMalformedToken';

  ResinMalformedToken.prototype.exitCode = 1;

  return ResinMalformedToken;

})(TypedError);


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

exports.ResinExpiredToken = ResinExpiredToken = (function(_super) {
  __extends(ResinExpiredToken, _super);

  function ResinExpiredToken(token) {
    this.token = token;
    ResinExpiredToken.__super__.constructor.call(this, "The token expired: " + this.token);
  }

  ResinExpiredToken.prototype.code = 'ResinExpiredToken';

  ResinExpiredToken.prototype.exitCode = 1;

  return ResinExpiredToken;

})(TypedError);


/**
 *	@summary Resin application not found
 * @class
 * @public
 *
 * @param {(String|Number)} application - application name or id
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinApplicationNotFound('MyApp')
 */

exports.ResinApplicationNotFound = ResinApplicationNotFound = (function(_super) {
  __extends(ResinApplicationNotFound, _super);

  function ResinApplicationNotFound(application) {
    this.application = application;
    ResinApplicationNotFound.__super__.constructor.call(this, "Application not found: " + this.application);
  }

  ResinApplicationNotFound.prototype.code = 'ResinApplicationNotFound';

  ResinApplicationNotFound.prototype.exitCode = 1;

  return ResinApplicationNotFound;

})(TypedError);


/**
 *	@summary Resin device not found
 * @class
 * @public
 *
 * @param {(String|Number)} device - device name or id
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinDeviceNotFound('MyDevice')
 */

exports.ResinDeviceNotFound = ResinDeviceNotFound = (function(_super) {
  __extends(ResinDeviceNotFound, _super);

  function ResinDeviceNotFound(device) {
    this.device = device;
    ResinDeviceNotFound.__super__.constructor.call(this, "Device not found: " + this.device);
  }

  ResinDeviceNotFound.prototype.code = 'ResinDeviceNotFound';

  ResinDeviceNotFound.prototype.exitCode = 1;

  return ResinDeviceNotFound;

})(TypedError);


/**
 *	@summary Resin ambiguous device
 * @class
 * @public
 *
 * @param {(String|Number)} device - device name or id
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinAmbiguousDevice('MyDevice')
 */

exports.ResinAmbiguousDevice = ResinAmbiguousDevice = (function(_super) {
  __extends(ResinAmbiguousDevice, _super);

  function ResinAmbiguousDevice(device) {
    this.device = device;
    ResinAmbiguousDevice.__super__.constructor.call(this, "Device is ambiguous: " + this.device);
  }

  ResinAmbiguousDevice.prototype.code = 'ResinAmbiguousDevice';

  ResinAmbiguousDevice.prototype.exitCode = 1;

  return ResinAmbiguousDevice;

})(TypedError);


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

exports.ResinAmbiguousApplication = ResinAmbiguousApplication = (function(_super) {
  __extends(ResinAmbiguousApplication, _super);

  function ResinAmbiguousApplication(application) {
    this.application = application;
    ResinAmbiguousApplication.__super__.constructor.call(this, "Application is ambiguous: " + this.application);
  }

  ResinAmbiguousApplication.prototype.code = 'ResinAmbiguousApplication';

  ResinAmbiguousApplication.prototype.exitCode = 1;

  return ResinAmbiguousApplication;

})(TypedError);


/**
 *	@summary Resin key not found
 * @class
 * @public
 *
 * @param {(String|Number)} key - key name, id or value
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinKeyNotFound('MyKey')
 */

exports.ResinKeyNotFound = ResinKeyNotFound = (function(_super) {
  __extends(ResinKeyNotFound, _super);

  function ResinKeyNotFound(key) {
    this.key = key;
    ResinKeyNotFound.__super__.constructor.call(this, "Key not found: " + this.key);
  }

  ResinKeyNotFound.prototype.code = 'ResinKeyNotFound';

  ResinKeyNotFound.prototype.exitCode = 1;

  return ResinKeyNotFound;

})(TypedError);


/**
 *	@summary Resin request error
 * @class
 * @public
 *
 * @param {String} body - response body
 * @param {Number} statusCode - http status code
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinRequestError('Unauthorized')
 */

exports.ResinRequestError = ResinRequestError = (function(_super) {
  __extends(ResinRequestError, _super);

  function ResinRequestError(body, statusCode) {
    this.body = body;
    this.statusCode = statusCode;
    ResinRequestError.__super__.constructor.call(this, "Request error: " + this.body);
  }

  ResinRequestError.prototype.code = 'ResinRequestError';

  ResinRequestError.prototype.exitCode = 1;

  return ResinRequestError;

})(TypedError);


/**
 *	@summary Resin not logged in
 * @class
 * @public
 *
 * @return {Error} error instance
 *
 * @example
 * throw new errors.ResinNotLoggedIn()
 */

exports.ResinNotLoggedIn = ResinNotLoggedIn = (function(_super) {
  __extends(ResinNotLoggedIn, _super);

  function ResinNotLoggedIn() {
    ResinNotLoggedIn.__super__.constructor.call(this, 'You have to log in');
  }

  ResinNotLoggedIn.prototype.code = 'ResinNotLoggedIn';

  ResinNotLoggedIn.prototype.exitCode = 1;

  return ResinNotLoggedIn;

})(TypedError);
