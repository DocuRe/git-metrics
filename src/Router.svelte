<script>
  //import Flare from "./Flare.svelte";
  //import TriageCount from "../TriageCount.svelte"
  import IssueAge from "./IssueAge.svelte";
  import config from "../config.json";

  let view = "issue";
  let orgrepo = config.repositories[0];
  let organization;
  let repository;

  $: [organization, repository] = orgrepo.split("/");

  function setView(v) {
    view = v;
  }
</script>

<nav>
  <button on:click={() => setView('issue')}>Issue Age</button>
  <button on:click={() => setView('triage')}>Triage Count</button>
</nav>

<select bind:value={orgrepo}>
  {#each config.repositories as repo}
    <option value={repo}>{repo}</option>
  {/each}
</select>

{#if view === 'issue'}
  <IssueAge {organization} {repository} />
{:else if view === 'flare'}
  <!--  <Flare {organization} {repository} />-->
{:else if view === 'triage'}
  <!--  <TriageCount {organization} />-->
  <!-- <Leaderboard  {organization} {repository} /> -->
{:else}Unknown view{/if}
