import App from './App.svelte';
import config from '../config.json';

const app = new App({
	target: document.body,
	props: {
		config
	}
});

export default app;