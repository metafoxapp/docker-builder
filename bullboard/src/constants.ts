import 'dotenv/config';
import { ConnectionOptions } from 'bullmq/dist/esm/interfaces';
import { ConnectionOptions as TLSConnectionOptions } from 'node:tls';

function normalizePath(pathStr: string): string {
	return (pathStr || '').replace(/\/$/, '');
}

const PROXY_PATH = normalizePath(process.env.PROXY_PATH);

const toInt = (input: string | undefined, value: number): number => {
	if (input) {
		return parseInt(input, 10);
	}
	return value;
};

export const queueNames: string = process.env.QUEUE_NAMES || 'facebook_tracker, twitter_tracker';

export const redisConnection: ConnectionOptions = {
	db: toInt(process.env.REDIS_DB, 0),
	host: process.env.REDIS_HOST || 'localhost',
	port: toInt(process.env.REDIS_PORT, 6379),
	username: process.env.REDIS_USERNAME,
	password: process.env.REDIS_PASSWORD,
	tls: process.env.REDIS_USE_TLS as unknown as TLSConnectionOptions
};

export const config = {
	PORT: process.env.PORT || 3000,
	ADMIN_USER: 'admin',
	ADMIN_PASSWORD: process.env.ADMIN_PASSWORD || 'admin',
	HOME_PAGE: '/',
	LOGIN_PAGE: `/login`
};

export default config;
