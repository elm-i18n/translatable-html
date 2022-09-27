import { defineConfig } from 'vite';
import { plugin as elm } from 'vite-plugin-elm';

export default defineConfig(({ command, mode }) => {
	const port = parseInt(process.env['PORT'] || '') || 3000;

	return {
		plugins: [
			elm({
				debug: true,
				optimize: false,
			}),
		],
		server: {
			port,
		},
	};
});
