<script>
  //import Flare from "./Flare.svelte";
  import Router from "svelte-spa-router";
  import TriageCount from "./TriageCount.svelte";
  import IssueAge from "./IssueAge.svelte";

  const routes = {
    '/issue': IssueAge,
    '/triage': TriageCount
  };
</script>

<nav>
  <a href="#/issue">Issue Age</a>
  |
  <a href="#/triage">Triage Count</a>
</nav>

<Router {routes} />
