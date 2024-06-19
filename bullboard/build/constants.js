"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.config = exports.redisConnection = exports.queueNames = void 0;
require("dotenv/config");
function normalizePath(pathStr) {
    return (pathStr || '').replace(/\/$/, '');
}
const PROXY_PATH = normalizePath(process.env.PROXY_PATH);
const toInt = (input, value) => {
    if (input) {
        return parseInt(input, 10);
    }
    return value;
};
exports.queueNames = process.env.QUEUE_NAMES || 'facebook_tracker, twitter_tracker';
exports.redisConnection = {
    db: toInt(process.env.REDIS_DB, 0),
    host: process.env.REDIS_HOST || 'localhost',
    port: toInt(process.env.REDIS_PORT, 6379),
    username: process.env.REDIS_USERNAME,
    password: process.env.REDIS_PASSWORD,
    tls: process.env.REDIS_USE_TLS
};
exports.config = {
    PORT: process.env.PORT || 3000,
    ADMIN_USER: 'admin',
    ADMIN_PASSWORD: process.env.ADMIN_PASSWORD || 'admin',
    HOME_PAGE: '/',
    LOGIN_PAGE: `/login`
};
exports.default = exports.config;
