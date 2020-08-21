<script>
	//import Flare from "./Flare.svelte";
	import Router, { location } from 'svelte-spa-router';
	import TriageCount from './TriageCount.svelte';
	import TriageIssues from './TriageIssues.svelte';
	import IssueAge from './IssueAge.svelte';
	import IssueBacklog from './IssueBacklog.svelte';
	import Owners from './Owners.svelte';

	const routes = {
		'/issue': IssueAge,
		'/triage': TriageCount,
		'/backlog': IssueBacklog,
		'/triage-issues/:organization/:column/:label': TriageIssues,
		'/owners': Owners,
	};
</script>

<style>
	:global(body) {
		padding: 0;
	}

	nav {
		background: #336374;
	}

	a {
		color: white;
		margin: 0 1em;
		display: inline-block;
		padding: 0.5em;
	}

	.active {
		background: rgba(255, 255, 255, 0.5);
		color: #000;
	}

	main {
		margin: 1em;
	}

	.github {
		float: right;
		padding: 0;
	}

	.github img {
		display: block;
	}
</style>

<nav>
	<a href="#/issue" class:active={$location === '/issue'}>Issue Age</a>
	<a href="#/backlog" class:active={$location === '/backlog'}>
		Issue Backlog
	</a>
	<a href="#/triage" class:active={$location === '/triage'}>Triage Count</a>
	<a href="#/owners" class:active={$location === '/owners'}>OWNERS Files</a>

	<a class="github" href="https://github.com/docure/git-metrics">
		<img width="85" height="35" src="GitHub_Logo_White.png" alt="GitHub" />
	</a>
</nav>

<main>
	<Router {routes} />
</main>
