<script>
  //import Flare from "./Flare.svelte";
  import TriageCount from "./TriageCount.svelte"
  import IssueAge from "./IssueAge.svelte";

  let view = "triage";

  function setView(v) {
    view = v;
  }
</script>

<nav>
  <button on:click={() => setView('issue')}>Issue Age</button>
  <button on:click={() => setView('triage')}>Triage Count</button>
</nav>

{#if view === 'issue'}
  <IssueAge />
{:else if view === 'flare'}
  <!--  <Flare />-->
{:else if view === 'triage'}
  <TriageCount />
  <!-- <Leaderboard  /> -->
{:else}Unknown view{/if}
