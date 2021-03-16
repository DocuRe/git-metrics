<script>
	import { getOwnerFiles } from './data.js';
	import { text } from 'svelte/internal';
	const config = window.config;

	let orgrepo = config.repositories[0];

	$: [organization, repository] = orgrepo.split('/');

	function getRepositoryOwnerFilesFromResult(res, repository) {
		//console.log(res.items);

		return res.items
			.filter(({ repository: { name } }) => name === repository)
			.sort((a, b) => (a.path < b.path ? -1 : 1));
	}
</script>

<style>
	pre {
		margin-left: 2em;
	}
</style>

<select bind:value={orgrepo}>
	{#each config.repositories as repo}
		<option value={repo}>{repo}</option>
	{/each}
</select>

{#await getOwnerFiles(organization)}
	Loading...
{:then res}
	{#each getRepositoryOwnerFilesFromResult(res, repository) as file}
		<p>
			<a href={file.html_url} target="_blank">{file.path}</a>
		</p>
		{#await fetch(file.html_url
				.replace(
					'https://github.com/',
					'https://raw.githubusercontent.com/'
				)
				.replace('/blob/', '/master/')).then((r) => r.text()) then text}
			<pre>{text}</pre>
		{/await}
	{/each}
{/await}
