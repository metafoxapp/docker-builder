"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.authRouter = void 0;
const passport_1 = __importDefault(require("passport"));
const express_1 = __importDefault(require("express"));
const constants_1 = require("./constants");
const passport_local_1 = require("passport-local");
exports.authRouter = express_1.default.Router();
passport_1.default.use(new passport_local_1.Strategy(function (username, password, cb) {
    if (username === constants_1.config.ADMIN_USER && password === constants_1.config.ADMIN_PASSWORD) {
        return cb(null, { user: 'bull-board' });
    }
    return cb(null, false);
}));
passport_1.default.serializeUser((user, cb) => {
    cb(null, user);
});
passport_1.default.deserializeUser((user, cb) => {
    cb(null, user);
});
exports.authRouter.route('/')
    .get((req, res) => {
    res.render('login');
})
    .post(passport_1.default.authenticate('local', {
    successRedirect: constants_1.config.HOME_PAGE,
    failureRedirect: constants_1.config.LOGIN_PAGE
}));
exports.default = exports.authRouter;
