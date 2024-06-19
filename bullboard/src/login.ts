import passport from 'passport';

import express from 'express';
import { config } from './constants';

import { Strategy as LocalStrategy } from 'passport-local';

export const authRouter = express.Router();

passport.use(new LocalStrategy(
	function(username, password, cb) {
		if (username === config.ADMIN_USER && password === config.ADMIN_PASSWORD) {
			return cb(null, { user: 'bull-board' });
		}

		return cb(null, false);
	})
);

passport.serializeUser((user, cb) => {
	cb(null, user);
});

passport.deserializeUser((user, cb) => {
	cb(null, user);
});

authRouter.route('/')
	.get((req, res) => {
		res.render('login');
	})
	.post(passport.authenticate('local', {
		successRedirect: config.HOME_PAGE,
		failureRedirect: config.LOGIN_PAGE
	}));

export default authRouter;
