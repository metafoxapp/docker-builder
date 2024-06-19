"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
var _a;
Object.defineProperty(exports, "__esModule", { value: true });
const api_1 = require("@bull-board/api");
const bullMQAdapter_1 = require("@bull-board/api//bullMQAdapter");
const express_1 = require("@bull-board/express");
const bullmq_1 = require("bullmq");
const express_2 = __importDefault(require("express"));
const express_session_1 = __importDefault(require("express-session"));
const passport_1 = __importDefault(require("passport"));
const connect_ensure_login_1 = require("connect-ensure-login");
const body_parser_1 = __importDefault(require("body-parser"));
const login_1 = require("./login");
const constants_1 = require("./constants");
const serverAdapter = new express_1.ExpressAdapter();
const { setQueues } = (0, api_1.createBullBoard)({
    queues: [],
    serverAdapter,
    options: {
        uiConfig: {
            boardTitle: (_a = process.env.SITE_TITLE) !== null && _a !== void 0 ? _a : 'Dashboard'
            // boardLogo: {
            // 	path: '',
            // 	width: 1,
            // 	height: 32
            // },
            // favIcon: {
            // 	default: 'https://metafox-dev.s3.amazonaws.com/kl/bgs/metafox-favicon.png',
            // 	alternative: 'https://metafox-dev.s3.amazonaws.com/kl/bgs/metafox-favicon.png'
            // }
        }
    }
});
const router = serverAdapter.getRouter();
const queueList = constants_1.queueNames
    .split(', ')
    .map(x => x.trim())
    .filter(Boolean)
    .map(queueName => {
    return new bullMQAdapter_1.BullMQAdapter(new bullmq_1.Queue(queueName, { connection: constants_1.redisConnection }), { allowRetries: true });
});
setQueues(queueList);
const app = (0, express_2.default)();
app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');
if (app.get('env') !== 'production') {
    const morgan = require('morgan');
    app.use(morgan('combined'));
}
const sessionOpts = {
    name: 'bull-board.sid',
    secret: Math.random().toString(),
    resave: false,
    saveUninitialized: false,
    cookie: {
        path: '/',
        httpOnly: false,
        secure: false
    }
};
app.use((0, express_session_1.default)(sessionOpts));
app.use(passport_1.default.initialize({}));
app.use(passport_1.default.session({
    pauseStream: false
}));
app.use(body_parser_1.default.urlencoded({ extended: false }));
app.use(constants_1.config.LOGIN_PAGE, login_1.authRouter);
app.use(constants_1.config.HOME_PAGE, (0, connect_ensure_login_1.ensureLoggedIn)(constants_1.config.LOGIN_PAGE), router);
app.listen(constants_1.config.PORT, () => {
    console.log(`bull-board is started http://localhost:${constants_1.config.PORT}${constants_1.config.HOME_PAGE}`);
    console.log(`bull-board is fetching queue list, please wait...`);
});
