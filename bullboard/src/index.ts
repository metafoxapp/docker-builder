import { createBullBoard } from '@bull-board/api';
import { BullMQAdapter } from '@bull-board/api//bullMQAdapter';
import { ExpressAdapter } from '@bull-board/express';
import { Queue } from 'bullmq';
import express from 'express';
import session from 'express-session';
import passport from 'passport';
import { ensureLoggedIn } from 'connect-ensure-login';
import bodyParser from 'body-parser';
import { authRouter } from './login';
import { config, queueNames, redisConnection } from './constants';

const serverAdapter = new ExpressAdapter();
const { setQueues } = createBullBoard({
  queues: [],
  serverAdapter,
  options: {
    uiConfig: {
      boardTitle: process.env.SITE_TITLE ?? 'Dashboard'
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
const queueList = queueNames
  .split(', ')
  .map(x => x.trim())
  .filter(Boolean)
  .map(queueName => {
    return new BullMQAdapter(
      new Queue(queueName, { connection: redisConnection }),
      { allowRetries: true }
    );
  });

setQueues(queueList);

const app = express();

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

app.use(session(sessionOpts));
app.use(passport.initialize({}));
app.use(
  passport.session({
    pauseStream: false
  })
);
app.use(bodyParser.urlencoded({ extended: false }));

app.use(config.LOGIN_PAGE, authRouter);
app.use(config.HOME_PAGE, ensureLoggedIn(config.LOGIN_PAGE), router);

app.listen(config.PORT, () => {
  console.log(
    `bull-board is started http://localhost:${config.PORT}${config.HOME_PAGE}`
  );
  console.log(`bull-board is fetching queue list, please wait...`);
});

