import { defineConfig } from 'vite';
import { plugin as elm } from 'vite-plugin-elm';

export default defineConfig(({ command, mode }) => {
	const port = parseInt(process.env['PORT'] || '') || 3000;

	return {
		plugins: [
			elm({
				debug: false,
				optimize: true,
			}),
		],
		server: {
			port,
			// TODO: disable HMR. Blocker: vite-plugin-elm does not recompile at all if HMR is disabled.
			// hmr: false,
		},
	};
});
