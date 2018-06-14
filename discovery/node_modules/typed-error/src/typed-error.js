"use strict";
var tslib_1 = require("tslib");
var BaseError = (function () {
    function BaseError() {
        Error.apply(this, arguments);
    }
    return BaseError;
}());
BaseError.prototype = Object.create(Error.prototype);
var getStackTrace;
if (Error.captureStackTrace != null) {
    var captureStackTrace_1 = Error.captureStackTrace;
    getStackTrace = function (e) {
        captureStackTrace_1(e, e.constructor);
    };
}
else {
    getStackTrace = function (e, err) {
        if (!(err instanceof Error)) {
            err = new Error(err);
        }
        if (err.stack != null) {
            e.stack = err.stack;
        }
    };
}
var TypedError = (function (_super) {
    tslib_1.__extends(TypedError, _super);
    function TypedError(err) {
        if (err === void 0) { err = ''; }
        var _this = _super.call(this) || this;
        if (err instanceof Error) {
            _this.message = err.message;
        }
        else {
            _this.message = err;
        }
        _this.name = _this.constructor.name;
        getStackTrace(_this, err);
        return _this;
    }
    return TypedError;
}(BaseError));
module.exports = TypedError;
//# sourceMappingURL=typed-error.js.map